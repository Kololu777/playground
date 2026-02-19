# lazygitメモ（キーとGit操作の対応）

## まず大前提

- lazygitは「どのパネルにいるか」でキーの意味が変わる。
- 迷ったら `?` で、その画面で有効なキー一覧を確認するのが最短。

## よく使うキー早見表

| キー | 主な文脈 | 意味 | Gitでの対応イメージ |
| --- | --- | --- | --- |
| `x` | 各パネル | 操作メニューを開く | 単一コマンドではなくランチャー |
| `c` | Files | ステージ済みをコミット | `git commit` |
| `s` | Files | 変更をstash | `git stash push` |
| `S` | Files | stash詳細オプション | `git stash push` のオプション付き |
| `m` | rebase/merge中 | abort/continue/skip など | `git rebase --abort/--continue/--skip`、`git merge --abort` |
| `u` | Branches/Remotes | upstream操作 | 追跡ブランチの設定/解除など |

補足:
- `c` や `m` はパネルによって別機能になることがある。
- `h`/`m`/`s` は、resetメニュー内で `hard`/`mixed`/`soft` を選ぶショートカットとして出ることがある。

## `reset` がややこしいポイント

- Commitsパネルで `g` を押すと、`soft` / `mixed` / `hard` のresetメニューが出る。
- ここで選ぶコミットは「消したいコミット」ではなく「戻したい先のコミット」。

## `git reset` / `git checkout -- .` / `git clean -fd` の違い

Gitは次の3層で考えると分かりやすい:
- `HEAD`: いまのコミット
- `Index` (staging): 次にコミットされる内容
- `Working tree`: 作業中ファイル

`git reset`:
- `--soft`: `HEAD` だけ戻す（Index/Working treeは保持）
- `--mixed` (デフォルト): `HEAD` と `Index` を戻す（Working treeは保持）
- `--hard`: `HEAD`/`Index`/`Working tree` を戻す（未コミット変更が消える）

`git checkout -- .`（今は `git restore .` 推奨）:
- trackedファイルの作業ツリー変更を戻す。
- 実体は「作業ツリーをIndexの内容で上書き」。

`git clean -fd`:
- untrackedファイル/ディレクトリを削除する。
- 実行前に `git clean -nd` でプレビューする。

## lazygitで近い操作（Filesパネル）

- `d`: ファイル単位で変更を捨てる（discard options）
- `D`: 作業ツリー全体を強く戻す系の操作

このあたりは、次の操作の入口になりやすい:
- tracked変更の破棄（`git restore <file>` 相当）
- untracked削除（`git clean -fd` 相当）
- まとめて大きく戻す（`git reset --hard` + `git clean -fd` 方向）

## 迷った時の最短手順

1. まず退避: Filesで `s`（stash）
2. rebase/mergeを中止: `m` -> `abort`
3. コミットを戻す: Commitsで `g` -> `soft`/`mixed`/`hard`（戻したい先を選ぶ）
4. untracked掃除: `git clean -nd` で確認してから `git clean -fd`
