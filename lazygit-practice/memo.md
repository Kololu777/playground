# lazygit: Files -> Reset (`D`) のキー対応

対象: `lazygit 0.58.1`

`Files` パネルで `D` を押して開く Reset メニューの意味だけをまとめる。

| キー | メニュー表示 | 実際の動作 | Git相当 |
| --- | --- | --- | --- |
| `x` | Nuke working tree | 作業ツリーを全消し（tracked/unstaged/staged/untracked）。確認あり。 | `git reset --hard HEAD && git clean -fd` |
| `c` | Discard untracked files | untrackedファイル/ディレクトリを削除 | `git clean -fd` |
| `u` | Discard any unstaged changes | unstagedのtracked変更を破棄 | `git checkout -- .` (`git restore .` 相当) |
| `S` | Discard staged changes | stagedだけを消す（内部的に staged を stash -> drop） | 「stagedだけ取り消し」 |
| `s` | Soft reset | `HEAD` だけ戻す | `git reset --soft HEAD` |
| `m` | mixed reset | `HEAD` と `Index` を戻す | `git reset --mixed HEAD` |

## 具体例（共通の初期状態）

初期状態を次で固定して、各キーを押した結果だけ比較する。

- `a.txt`: tracked。内容を `v1 -> v2-unstaged` に変更（未ステージ）
- `c.txt`: 新規作成してステージ済み
- `b.txt`: 新規作成（untracked）

`git status --short` はこうなる:

```bash
 M a.txt
A  c.txt
?? b.txt
```

### `x` (Nuke working tree)

```bash
# after
# (clean)
```

- `a.txt` は `v1` に戻る
- `b.txt` と `c.txt` は消える

### `c` (Discard untracked files)

```bash
# after
 M a.txt
A  c.txt
```

- `b.txt` だけ消える
- staged/unstaged の tracked 変更は残る

### `u` (Discard any unstaged changes)

```bash
# after
A  c.txt
?? b.txt
```

- `a.txt` の未ステージ変更だけ消えて `v1` に戻る
- `c.txt` の staged は残る
- `b.txt` も残る

### `S` (Discard staged changes)

```bash
# after
 M a.txt
?? b.txt
```

- staged を落とすので `c.txt`（新規で staged だったファイル）は消える
- `a.txt` の未ステージ変更は残る
- `b.txt` は残る

### `s` (Soft reset)

```bash
# after
 M a.txt
A  c.txt
?? b.txt
```

- このメニューでは `git reset --soft HEAD` なので、実質変化なし

### `m` (mixed reset)

```bash
# after
 M a.txt
?? b.txt
?? c.txt
```

- index が `HEAD` に戻る
- `c.txt` は staged 解除されて untracked になる
- `a.txt` の未ステージ変更は残る

補足:
- 同じ `Files` パネルでも `d`（小文字）は「選択ファイルの discard メニュー」で、`D`（大文字）とは別。
- `D` メニューには `h`（hard reset = `git reset --hard HEAD`）もあるが、ここでは質問対象外なので省略。
- `S` は内部的に `stash --staged` を使うので、同一ファイルで staged/unstaged が複雑に重なると失敗するケースがある。

確認元:
- `pkg/gui/controllers/workspace_reset_controller.go`

x, u,c, S, s, m, hがよくわからんgit reset , git checkout -- . git clean -fdなんだの
思考時間: 3m 42s

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
