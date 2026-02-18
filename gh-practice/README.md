# gh の使い方メモ

GitHub CLI（`gh`）の基本操作をまとめます。

## 1. セットアップ

```bash
# バージョン確認
gh --version

# GitHub にログイン
gh auth login

# ログイン状態確認
gh auth status
```

## 2. リポジトリを扱う

```bash
# リポジトリをクローン
gh repo clone Kololu777/playground

# ブラウザでリポジトリを開く
gh repo view --web

# 現在ディレクトリで新規リポジトリ作成
gh repo create
```

## 3. Issue 操作

```bash
# Issue 一覧
gh issue list

# Issue 作成
gh issue create

# Issue 詳細を見る
gh issue view 123
```

## 4. Pull Request 操作

```bash
# PR 作成
gh pr create

# PR 一覧
gh pr list

# PR 詳細を見る
gh pr view 45

# PR を checkout
gh pr checkout 45
```

## 5. よく使う補助コマンド

```bash
# 直近 20 件のワークフロー実行を確認
gh run list --limit 20

# 失敗したワークフローのログ確認
gh run view <run-id> --log-failed

# api 経由で情報を取得（例: 自分のユーザー情報）
gh api user
```

## 6. ヘルプの見方

```bash
# 全体ヘルプ
gh help

# サブコマンドのヘルプ
gh pr --help
gh issue --help
```

必要ならこのファイルに「実際の作業フロー（branch 作成 → push → PR 作成）」も追記できます。
