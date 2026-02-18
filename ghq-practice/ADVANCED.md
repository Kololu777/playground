# ghq アドバンスな使い方

## 1. 複数 root を使い分ける（仕事/個人）

```bash
# 一時的に「仕事root」を既定にする（このシェルだけ有効）
export GHQ_ROOT="$HOME/ghq-work"
ghq root

# 一時的に「個人root」に切り替える
export GHQ_ROOT="$HOME/ghq-private"
ghq root
```

```bash
# 1コマンドだけ切り替えるなら prefix が安全
GHQ_ROOT="$HOME/ghq-work" ghq get cli/cli
GHQ_ROOT="$HOME/ghq-private" ghq get cli/cli
```

```bash
# 永続化して複数root運用する場合（ghq.root を複数登録）
git config --global --unset-all ghq.root
git config --global --add ghq.root "$HOME/ghq-private"
git config --global --add ghq.root "$HOME/ghq-work"  # 最後に追加した root が既定

# ghq が認識している root 一覧
ghq root --all
```

ポイント:

- `ghq get` / `ghq create` の保存先は `ghq root` の 1 行目
- `ghq.root` は「最後に追加した値」が先頭になる（= 既定になる）
- `GHQ_ROOT` で切り替えるときは単一パスにする（`A:B` は `ghq get` で意図どおり動かない環境がある）
- どこに入ったか迷ったら `ghq list -p <query>` でフルパス確認

## 2. 取得オプションを使う

```bash
# 既存 repo を更新
ghq get -u cli/cli

# SSH で clone
ghq get -p cli/cli

# 浅い clone（履歴を最小化）
ghq get --shallow cli/cli

# 特定ブランチだけ取得（single-branch）
ghq get -b main cli/cli
```

## 3. 探索を速くする（exact match / fzf）

```bash
# user/repo を完全一致で探す
ghq list -e Kololu777/playground

# ユニークなサブパスだけ表示
ghq list --unique
```

```bash
# fzf で選んで移動（複数 root でも安全に動く）
repo="$(ghq list -p | fzf)" && cd "$repo"
```

## 4. 空 repo を ghq 配下に作る

```bash
# host/user/repo 形式で作成
ghq create github.com/Kololu777/sandbox-repo
```

`ghq create` は内部で `git init` されるので、すぐ作業開始できます。

## 5. repo 削除は dry-run で確認してから

```bash
# まず削除対象だけ確認
ghq rm --dry-run github.com/Kololu777/sandbox-repo

# 実行時は確認プロンプトが出る
ghq rm github.com/Kololu777/sandbox-repo
```

## 6. 既存ローカル repo を ghq 配下へ移動

このディレクトリの `move-ghq.sh` を使うと、`origin` URL から正しい配置先を組み立てて移動できます。

```bash
source ghq-practice/move-ghq.sh
move_repo_to_ghq /path/to/existing/repo
```
