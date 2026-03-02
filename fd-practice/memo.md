# fd の使い方メモ

> 練習問題は tutorial/exercise.sh を実行してインタラクティブに試せる。

`fd` は、`find` コマンドのモダンな代替ツール。
デフォルトで高速・カラー出力・`.gitignore` 対応・正規表現サポートと、日常的なファイル検索が圧倒的に楽になる。

## 1. まず何が便利か

- `find` より圧倒的にシンプルな構文
- デフォルトで `.git/`、`node_modules/` など `.gitignore` 対象を除外
- 正規表現がデフォルト（`-g` でグロブも可）
- カラー出力で見やすい

## 2. 基本: ファイル名で検索

```bash
# カレントディレクトリ以下から "memo" を含むファイルを検索
fd memo

# 特定ディレクトリ以下を検索
fd memo ~/projects

# 大文字小文字を区別しない（デフォルトは smart case）
fd -i readme
```

`fd` は smart case: パターンが全て小文字なら case-insensitive、大文字を含むと case-sensitive になる。

## 3. 拡張子で絞り込む (-e)

```bash
# .md ファイルだけ検索
fd -e md

# .ts ファイルで "component" を含むもの
fd -e ts component

# 複数の拡張子
fd -e js -e ts -e tsx
```

`-e` は最もよく使うオプション。`find -name "*.md"` の代替。

## 4. ファイルタイプで絞り込む (-t)

```bash
# ファイルだけ（ディレクトリ除外）
fd -t f memo

# ディレクトリだけ
fd -t d src

# シンボリックリンクだけ
fd -t l

# 空ファイルだけ
fd -t e
```

| タイプ | 意味 |
| --- | --- |
| `f` | 通常ファイル |
| `d` | ディレクトリ |
| `l` | シンボリックリンク |
| `e` | 空ファイル |
| `x` | 実行可能ファイル |

## 5. 隠しファイル・無視ファイルの扱い (-H / -I)

```bash
# 隠しファイルも検索対象にする
fd -H .bashrc

# .gitignore で無視されたファイルも検索対象にする
fd -I node_modules

# 両方（全ファイルが対象）
fd -HI
```

デフォルトでは隠しファイルと `.gitignore` 対象は除外される。
`-H` と `-I` で明示的に含められる。

## 6. 検索深度の制限 (-d)

```bash
# 1階層だけ（ls のように使える）
fd -d 1

# 最大3階層まで
fd -d 3 -e py
```

巨大なリポジトリで結果を絞りたいときに便利。

## 7. グロブパターン (-g)

```bash
# グロブパターンで検索（正規表現ではなくグロブ）
fd -g '*.test.ts'

# 特定のディレクトリパターン
fd -g 'src/**/index.ts'
```

デフォルトは正規表現。`-g` を付けるとグロブモードになる。

## 8. 正規表現で検索

```bash
# デフォルトは正規表現
fd '^test_.*\.py$'

# 数字3桁を含むファイル
fd '[0-9]{3}'

# "log" で始まるか "log" で終わるファイル
fd '(^log|log$)'
```

## 9. パスも含めて検索 (-p)

```bash
# パス全体をマッチ対象にする
fd -p 'src/components/.*\.tsx$'

# 特定ディレクトリ配下のファイルだけ
fd -p 'test/.*\.spec'
```

デフォルトではファイル名だけがマッチ対象。`-p` でフルパスが対象になる。

## 10. 除外パターン (-E)

```bash
# node_modules を除外して検索
fd -E node_modules -e js

# 複数除外
fd -E '*.min.js' -E dist -E build

# テストファイルを除外
fd -E '*test*' -E '*spec*' -e ts
```

## 11. コマンド実行 (-x / -X)

```bash
# 見つかったファイルそれぞれに対してコマンド実行
fd -e png -x convert {} {.}.webp

# 見つかった全ファイルを一括でコマンドに渡す
fd -e py -X wc -l

# 確認用: ファイルの詳細を表示
fd -e log -x ls -lh {}
```

| プレースホルダ | 意味 | 例 (`src/app/main.rs`) |
| --- | --- | --- |
| `{}` | パス全体 | `src/app/main.rs` |
| `{/}` | ファイル名 | `main.rs` |
| `{//}` | 親ディレクトリ | `src/app` |
| `{.}` | 拡張子を除いたパス | `src/app/main` |
| `{/.}` | 拡張子を除いたファイル名 | `main` |

`-x` の構文は `fd [検索] -x コマンド [引数...]`。プレースホルダはコマンドの**引数の中で**使う。

```bash
fd -e ts -x echo '{.}'       # echo に渡す → パスが表示される
fd -e ts -x wc -l '{}'       # wc に渡す → 行数が出る
fd -e ts -x mv '{}' '{.}.js' # mv に渡す → リネームされる

# ❌ プレースホルダをコマンド位置に置くと、パスをコマンドとして実行しようとする
fd -e ts -x '{.}'
# → [fd error]: Command not found: src/utils/index
```

> **⚠️ zsh ではプレースホルダを必ずクォートすること。**
> `{}` や `{.}` はシェルのブレース展開と衝突し、意図しないファイル操作が起きる。
> ```bash
> # ❌ zsh が {} を展開 → ファイルが壊れる
> fd -e js -x mv {} {.}.jsx
>
> # ✅ シングルクォートで保護
> fd -e js -x mv '{}' '{.}.jsx'
> ```

## 12. サイズ・更新日時で絞り込む (-S / --changed-within)

```bash
# 1MB 以上のファイル
fd -S +1m

# 100KB 未満のファイル
fd -S -100k

# 最近1日以内に更新されたファイル
fd --changed-within 1d

# 1週間以上前に更新されたファイル
fd --changed-before 1w

# 組み合わせ: 最近変更された大きなログファイル
fd -e log -S +10m --changed-within 7d
```

### --changed-within / --changed-before 早見表

- `--changed-within` = 「〜以内に変更」(新しいやつ)
- `--changed-before` = 「〜より前に変更」(古いやつ)
- `--changed-after` は `--changed-within` のエイリアス

```
fd --changed-within 30m      # 30分以内
fd --changed-within 2h       # 2時間以内
fd --changed-within 1d       # 1日以内
fd --changed-within 1w       # 1週間以内
fd --changed-before 2025-06-01  # 日付を直接指定もOK
```

| 単位 | 意味 |
| --- | --- |
| `s` | 秒 |
| `m` | 分 |
| `h` | 時間 |
| `d` | 日 |
| `w` | 週 |

## 13. 出力フォーマット

```bash
# null 区切りで出力（xargs -0 と組み合わせ）
fd -0 -e rs | xargs -0 wc -l

# 絶対パスで出力
fd -a -e md

# 1件だけ出力
fd -1 README
```

## 14. 実践パターン

### find の置き換え

```bash
# ❌ find（長い）
find . -name "*.ts" -not -path "*/node_modules/*" -not -path "*/.git/*"

# ✅ fd（短い、しかもデフォルトで .gitignore 対応）
fd -e ts
```

### プロジェクト内の特定ファイル探し

```bash
# 設定ファイルを探す
fd -H -d 2 -g '*.config.*'
fd -H -d 2 -g '.*rc'
fd -H -d 2 -g '.*rc.js'

# Dockerfile を探す
fd -g 'Dockerfile*'
```

### 一括リネーム

```bash
# .jpeg → .jpg に一括リネーム
fd -e jpeg -x mv {} {.}.jpg

# ファイル名の prefix を変更
fd -g 'old_*' -x rename 's/old_/new_/' {}
```

### fzf との連携

```bash
# fd の結果を fzf で絞り込んで vim で開く
fd -e py | fzf | xargs nvim

# プレビュー付き
fd -e ts | fzf --preview 'bat --color=always {}' | xargs nvim
```

### 不要ファイルの掃除

```bash
# .DS_Store を見つけて削除
fd -HI -g '.DS_Store' -x rm {}

# __pycache__ を掃除
fd -HI -t d '__pycache__' -x rm -rf {}
```

## 15. fd vs find

| 項目 | `fd` | `find` |
| --- | --- | --- |
| 構文 | シンプル | 冗長 |
| 速度 | 高速（並列処理） | 普通 |
| `.gitignore` 対応 | デフォルトで除外 | 非対応 |
| 正規表現 | デフォルト | `-regex` が必要 |
| カラー出力 | デフォルト | なし |
| 隠しファイル | デフォルト除外 | デフォルト含む |

`find` が必要なケース: パーミッション検索 (`-perm`)、所有者検索 (`-user`)、`-exec` の細かい制御など。

## よく使うオプション早見表

| オプション | 意味 |
| --- | --- |
| `-e EXT` | 拡張子で絞り込み |
| `-t TYPE` | ファイルタイプ (f/d/l/e/x) |
| `-H` | 隠しファイルを含む |
| `-I` | `.gitignore` 対象を含む |
| `-d DEPTH` | 検索深度の上限 |
| `-g` | グロブモードで検索 |
| `-p` | フルパスでマッチ |
| `-E PATTERN` | 除外パターン |
| `-x CMD` | 各ファイルにコマンド実行 |
| `-X CMD` | 全ファイルを一括でコマンドに渡す |
| `-S SIZE` | サイズで絞り込み |
| `-a` | 絶対パスで出力 |
| `-0` | null 区切り出力 |
| `-1` | 最初の1件だけ出力 |
| `--changed-within` | 更新日時で絞り込み（以内） |
| `--changed-before` | 更新日時で絞り込み（以前） |
