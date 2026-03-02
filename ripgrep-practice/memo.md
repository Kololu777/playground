# ripgrep (rg) の使い方メモ

> 練習問題は exercise.sh を実行してインタラクティブに試せる。

`ripgrep` (`rg`) は高速なテキスト検索ツール。`grep -r` の上位互換。
デフォルトで `.gitignore` を尊重し、隠しファイル・バイナリをスキップする。

## 1. 基本: パターン検索

```bash
# カレントディレクトリ以下から "TODO" を検索
rg TODO

# 特定ディレクトリを指定
rg TODO src/

# 特定ファイルを指定
rg TODO main.py
```

出力は `ファイル名:行番号:マッチ行` の形式。

## 2. 大文字小文字

```bash
# 大文字小文字を無視 (-i)
rg -i todo

# スマートケース (-S): パターンが全部小文字なら case-insensitive、大文字を含めば case-sensitive
rg -S todo    # → TODO も todo も Todo もヒット
rg -S TODO    # → TODO だけヒット
```

## 3. ファイルタイプで絞り込み (-t / -T)

```bash
# Python ファイルだけ検索
rg -t py "import requests"

# JavaScript + TypeScript
rg -t js -t ts "console.log"

# Python を除外して検索
rg -T py TODO

# 対応しているタイプ一覧
rg --type-list
```

## 4. glob パターンで絞り込み (-g)

```bash
# .tsx ファイルだけ
rg -g "*.tsx" useState

# テストファイルを除外
rg -g "!*test*" TODO

# 特定ディレクトリを除外
rg -g "!node_modules" -g "!dist" TODO
```

`-t` は事前定義のタイプ、`-g` は自由な glob パターン。

## 5. コンテキスト表示 (-A / -B / -C)

```bash
# マッチ行の前後 3 行を表示
rg -C 3 "def main"

# マッチ行の後 5 行
rg -A 5 "function"

# マッチ行の前 2 行
rg -B 2 "error"
```

## 6. 正規表現

```bash
# デフォルトで正規表現が使える
rg "fn\s+\w+\(" src/

# IPv4 アドレスっぽい文字列を検索
rg "\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}"

# 固定文字列として検索（正規表現を無効化）(-F)
rg -F "user.name()" src/
```

`-F` は `.` や `()` をエスケープせずにリテラル検索したいときに便利。

## 7. ファイル名だけ表示 (-l / -L)

```bash
# マッチしたファイル名だけ表示
rg -l TODO

# マッチしなかったファイル名を表示
rg --file-without-match TODO
```

## 8. マッチ数を表示 (-c)

```bash
# ファイルごとのマッチ数
rg -c TODO

# 総マッチ数だけ知りたい
rg -c TODO | awk -F: '{sum+=$2} END{print sum}'
# または --count-matches
rg --count-matches TODO
```

## 9. 置換 (-r)

```bash
# マッチ部分を置換して表示（ファイルは変更されない）
rg "foo" -r "bar"

# キャプチャグループを使った置換
rg "(\w+)_test\.py" -r '${1}_spec.py'
```

`rg -r` はプレビューのみ。実際にファイルを書き換えるには `sed` と組み合わせる:

```bash
rg -l "old_name" | xargs sed -i '' 's/old_name/new_name/g'
```

## 10. 隠しファイル・gitignore 無視ファイルも検索

```bash
# 隠しファイルも検索 (--hidden)
rg --hidden TODO

# .gitignore を無視して検索 (--no-ignore)
rg --no-ignore TODO

# 両方
rg --hidden --no-ignore TODO

# 短縮: unrestricted (-u)
rg -u TODO          # --no-ignore 相当
rg -uu TODO         # --no-ignore --hidden 相当
rg -uuu TODO        # --no-ignore --hidden --binary 相当
```

## 11. マルチライン検索 (-U)

```bash
# 複数行にまたがるパターン
rg -U "struct \w+\s*\{[^}]*name"

# --multiline-dotall で . が改行にもマッチ
rg -U --multiline-dotall "BEGIN.*END"
```

## 12. JSON 出力 (--json)

```bash
# JSON 形式で出力（スクリプト連携向け）
rg --json TODO | head -5
```

`jq` と組み合わせてプログラム的に処理できる。

## 13. 実践パターン

### fzf と組み合わせてインタラクティブ検索

```bash
# rg の結果を fzf でプレビュー付き選択 → vim で開く
rg --line-number --no-heading . | fzf --delimiter : --preview 'bat --color=always {1} --highlight-line {2}' | awk -F: '{print "+"$2, $1}' | xargs nvim
```

### 特定パターンを含むファイルだけ別コマンドに渡す

```bash
# TODO を含む Python ファイルだけ lint
rg -t py -l TODO | xargs ruff check
```

### プロジェクト内の未使用 export を探す手がかり

```bash
# export されている関数名を抽出
rg "export (function|const|class) (\w+)" -or '$2' src/ --no-filename | sort -u > /tmp/exports.txt
```

### 設定ファイル (.ripgreprc)

```bash
# 環境変数で設定ファイルを指定
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
```

```
# ~/.ripgreprc の例
--smart-case
--hidden
--glob=!.git
--glob=!node_modules
```

## 14. rg vs grep

| 特徴 | `rg` | `grep -r` |
| --- | --- | --- |
| 速度 | 非常に速い | 普通 |
| `.gitignore` 尊重 | デフォルトで有効 | なし |
| 隠しファイル | デフォルトでスキップ | 検索する |
| バイナリ | デフォルトでスキップ | 検索する |
| Unicode | 完全対応 | 環境依存 |
| ファイルタイプ | `-t py` 等 | なし |
| 色付き出力 | デフォルト | `--color=auto` 必要 |

## よく使うオプション早見表

| オプション | 意味 |
| --- | --- |
| `-i` | 大文字小文字を無視 |
| `-S` | スマートケース |
| `-F` | 固定文字列（正規表現を無効化） |
| `-w` | 単語単位でマッチ |
| `-t TYPE` | ファイルタイプで絞り込み |
| `-T TYPE` | ファイルタイプを除外 |
| `-g GLOB` | glob パターンで絞り込み |
| `-l` / `-L` | マッチした / しなかったファイル名だけ |
| `-c` | ファイルごとのマッチ数 |
| `-A N` / `-B N` / `-C N` | 後 / 前 / 前後 N 行を表示 |
| `-r REPLACE` | 置換プレビュー |
| `-U` | マルチライン検索 |
| `--hidden` | 隠しファイルも検索 |
| `-u` / `-uu` / `-uuu` | unrestricted (段階的に制限解除) |
| `--json` | JSON 形式で出力 |
| `-n` | 行番号表示 (デフォルト ON) |
| `--no-heading` | ファイル名をグループ化しない |
