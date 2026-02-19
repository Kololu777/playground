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
