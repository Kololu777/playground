# pgrep の使い方メモ

`pgrep` は、プロセス名やその他の属性でプロセスを検索し、PID を返すコマンド。
`ps aux | grep xxx | grep -v grep` のような冗長な書き方を置き換える。

## 1. 基本: プロセス名で検索

```bash
# "node" を含むプロセスの PID を表示
pgrep node

# プロセス名も一緒に表示 (-l)
pgrep -l node

# コマンドライン全体も表示 (-a)
pgrep -a node
```

`-l` は PID + プロセス名、`-a` は PID + フルコマンドライン。

## 2. 完全一致 (-x)

```bash
# "node" に完全一致するプロセスだけ
pgrep -x node

# "nod" では node はヒットしない
pgrep -x nod  # → 何も出ない
```

デフォルトは部分一致。`-x` で完全一致になる。

## 3. 特定ユーザーのプロセス (-u)

```bash
# 自分のプロセスから "python" を探す
pgrep -u "$USER" python

# root のプロセスから探す
pgrep -u root sshd
```

## 4. 最新/最古のプロセスだけ (-n / -o)

```bash
# 最も新しい node プロセスの PID
pgrep -n node

# 最も古い node プロセスの PID
pgrep -o node
```

複数の同名プロセスがあるとき、1 つだけ絞りたい場合に便利。

## 5. フルコマンドラインで検索 (-f)

```bash
# コマンドライン引数まで含めて検索
pgrep -f "node.*server.js"

# "python manage.py runserver" を探す
pgrep -af "manage.py runserver"
```

デフォルトではプロセス名（実行ファイル名）だけがマッチ対象。
`-f` を付けるとコマンドライン全体が対象になる。

## 6. カウント (-c)

```bash
# マッチするプロセスの数を表示
pgrep -c node
```

## 7. 区切り文字の変更 (-d)

```bash
# PID をカンマ区切りで出力
pgrep -d, node
# → 12345,12346,12347
```

`kill` や `xargs` に渡すときにフォーマットを調整できる。

## 8. 実践パターン

### プロセスの存在チェック（スクリプト向け）

```bash
if pgrep -x node > /dev/null; then
  echo "node is running"
else
  echo "node is not running"
fi
```

`pgrep` はマッチしたら exit 0、しなかったら exit 1 を返す。

### 特定プロセスを kill

```bash
# pkill で直接シグナルを送る（pgrep の kill 版）
pkill -f "node.*dev-server"

# SIGTERM ではなく SIGKILL を送る
pkill -9 -f "node.*dev-server"

# まず pgrep で確認してから kill
pgrep -af "node.*dev-server"   # 対象を目視確認
pkill -f "node.*dev-server"    # 問題なければ kill
```

### 特定プロセスの詳細を ps で見る

```bash
# pgrep で得た PID を ps に渡す
ps -p "$(pgrep -d, node)" -o pid,user,%cpu,%mem,command
```

## 9. pgrep vs ps | grep

```bash
# ❌ 冗長（grep 自身もヒットするので grep -v が必要）
ps aux | grep node | grep -v grep

# ✅ シンプル
pgrep -a node
```

`pgrep` は自分自身のプロセスを除外してくれるので、`grep -v grep` が不要。

## 10. macOS と Linux の差異

| 機能 | Linux (procps) | macOS (BSD) |
| --- | --- | --- |
| `-a` (フルコマンド表示) | ✅ | ❌ (`-fl` で代替) |
| `-f` (フルコマンドで検索) | ✅ | ✅ |
| `-c` (カウント) | ✅ | ✅ |
| `-d` (デリミタ) | ✅ | ✅ (`-d` ) |
| `-P` (親PID指定) | ✅ | ✅ |

macOS では `-a` が使えないため、`pgrep -fl node` でプロセス名 + コマンドラインを表示する。

## よく使うオプション早見表

| オプション | 意味 |
| --- | --- |
| `-l` | PID + プロセス名 |
| `-a` | PID + フルコマンドライン (Linux) |
| `-f` | コマンドライン全体を検索対象にする |
| `-x` | 完全一致 |
| `-u USER` | 指定ユーザーのプロセス |
| `-n` | 最新のマッチだけ |
| `-o` | 最古のマッチだけ |
| `-c` | マッチ数を表示 |
| `-d SEP` | PID の区切り文字を指定 |
| `-P PPID` | 親PIDで絞り込み |
