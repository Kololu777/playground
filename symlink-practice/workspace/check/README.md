# シンボリックリンク練習メモ

`ln -s 実体 リンク名` で作成します。`-s` は `symbolic` の略です。

## 1. 作る
```bash
cd symlink-practice/workspace/links
ln -s ../../source/docs/readme.txt readme-link.txt
ln -s ../../source/docs/'daily note.txt' daily-note-link.txt
ln -s ../../source/config config-link
```

## 2. 確認する
```bash
ls -l
readlink readme-link.txt
cat readme-link.txt
```

## 3. 外す（リンクだけ削除）
```bash
rm readme-link.txt
# または
unlink readme-link.txt
```

## 4. 同名がすでにあるとき
安全にやる（推奨）:
```bash
cd symlink-practice/workspace/links
target="readme-link.txt"
ts=$(date +%Y%m%d-%H%M%S)

if [ -e "$target" ] || [ -L "$target" ]; then
  mv -- "$target" "${target}.bak.${ts}"
fi

ln -s ../../source/docs/readme.txt "$target"
```

素早く上書き:
```bash
ln -sfn ../../source/docs/readme.txt readme-link.txt
```

- `-f`: 既存を消して上書き
- `-n`: 既存名が「ディレクトリへのシンボリックリンク」でも、そのリンク自体を置き換える

## 5. 壊れたリンクを試す（復元つき）
```bash
cd symlink-practice/workspace/links
ln -s ../../source/docs/readme.txt temp-link.txt
mv ../../source/docs/readme.txt ../../trash/readme.txt

ls -l temp-link.txt
cat temp-link.txt

# 復元
mv ../../trash/readme.txt ../../source/docs/readme.txt
```
