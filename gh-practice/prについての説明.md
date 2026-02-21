# PRについての説明

## PRとは

PR（Pull Request）は、作業ブランチの変更をベースブランチ（例: `main`）に取り込んでもらうための依頼です。  
コードを共有し、レビューを受け、問題がなければマージします。

## PRの基本フロー

1. 作業ブランチを作る  
2. 変更をコミットして GitHub に push  
3. PRを作成  
4. レビュー対応（コメント修正・再push）  
5. CI（テスト）が通る  
6. 承認後にマージ

## `gh`での実践コマンド

```bash
# 1) ブランチ作成
git switch -c feature/add-login

# 2) 変更をコミットしてpush
git add .
git commit -m "Add login form"
git push -u origin feature/add-login

# 3) PR作成（対話形式）
gh pr create

# 4) PR一覧 / 詳細確認
gh pr list
gh pr view 45

# 5) レビューのためにPRをローカルで取得
gh pr checkout 45

# 6) マージ（例: squash）

gh pr merge 45 --squash --delete-branch
```

## マージ方式の違い

- `--merge`: 通常マージ。履歴をそのまま残す。  
- `--squash`: コミットを1つにまとめてマージ。履歴が整理しやすい。  
- `--rebase`: ベースに積み直して直線的な履歴にする。

### 具体例（同じPR #45を3方式でマージ）

前提:
- `main` の最新コミットは `C`
- PR #45 のブランチには `D`, `E` の2コミットがある

```
main:    A - B - C
feature:       \- D - E
```

#### 1. `--merge` の場合

```bash
gh pr merge 45 --merge
```

結果: マージコミット `M` が作られる。

```
A - B - C ------- M   (main)
       \- D - E --/
```

ポイント:
- `D`, `E` がそのまま残る
- 分岐と合流が履歴に残る

#### 2. `--squash` の場合

```bash
gh pr merge 45 --squash
```

結果: `D`, `E` が1つにまとまった `S` として `main` に入る。

```
A - B - C - S   (main)
```

ポイント:
- `main` 側は1コミットだけ増える
- PR内の細かいコミット履歴は `main` には残らない

#### 3. `--rebase` の場合

```bash
gh pr merge 45 --rebase
```

結果: `D`, `E` が `main` の先頭に積み直され、`D'`, `E'` として直線につながる。

```
A - B - C - D' - E'   (main)
```

ポイント:
- 履歴が一直線になる
- コミットIDは再作成される（`D`, `E` とは別物）

## よくある詰まりポイント

- 必須チェック（CI）が失敗している  
- レビュー承認が足りない  
- `main` が先に進んでコンフリクトしている  
- ブランチ保護ルールで直接マージできない

### Draft のままでマージできないとき

エラー例:

```text
GraphQL: Pull Request is still a draft (mergePullRequest)
```

対処:

```bash
# Draft解除（Ready for review にする）
gh pr ready 2

# 状態確認
gh pr view 2 --json isDraft,mergeStateStatus,reviewDecision

# 解除後にマージ
gh pr merge 2 --squash --delete-branch
```

## 補足

`gh pr merge` が失敗するときは、まず `gh pr view <番号>` で状態（レビュー・チェック・コンフリクト）を確認すると早いです。


remote側にあわせるには？

● cd ~/.config/nix-config && git pull --rebase origin main

  これでローカルの main がリモートのsquash
  commitに合わせてリベースされます。

  もしローカルに未コミットの変更がなければ、より単純に：

  git reset --hard origin/main

  でもOKです（ローカルの main をリモートと完全に一致させる）。
