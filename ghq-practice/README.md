# ghq の使い方メモ

`ghq` は、Git リポジトリを決まったルールでまとめて管理するためのツールです。
リポジトリを `~/ghq/<ホスト名>/<ユーザー>/<リポジトリ名>` のような形で保存できるので、ローカル環境が散らかりにくくなります。

## 1. まず何が便利か

- clone 先を毎回考えなくてよい
- リポジトリの保存場所が統一される
- `ghq list` で手元の repo を一覧できる

## 2. セットアップ確認

```bash
# インストール済みか確認
ghq --version

# ルートディレクトリ確認
ghq root
```

## 3. よく使うコマンド

```bash
# GitHub から取得（clone）
ghq get https://github.com/cli/cli
# または短縮形
ghq get cli/cli

# ローカルにある repo を一覧
ghq list

# フルパスで表示
ghq list -p

# 既存 repo の場所を検索
ghq list | grep playground
```

## 4. 実際の流れ（practice）

```bash
# 1) どこに保存されるか確認
ghq root

# 2) リポジトリ取得
ghq get Kololu777/playground

# 3) 取得先へ移動
cd "$(ghq root)/github.com/Kololu777/playground"

# 4) 状態確認
git remote -v
git branch -a
```

## 5. 補足

`ghq` 単体にはインタラクティブ選択機能はありません。
必要なら `peco` / `fzf` と組み合わせると、`ghq list` から素早く移動できるようになります。

アドバンスな運用は `ghq-practice/ADVANCED.md` に分離しています。
