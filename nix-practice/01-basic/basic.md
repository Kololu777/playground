Note:
nix eval --file ooo.nix
で実行できます。

```nix
builtins.typeOf <調べたい変数>
```

# nix言語の型
nix言語の基本として、基本的な型としてどのようなものがあり、どのように扱うかについてを見ていきましょう。
型の紹介でその詳しい使い方について別のドキュメントに記載します。

# string型
ダブルクォートで文字を囲むことで宣言します。
```nix
"hello world"
```

# int型
整数型です。
```nix
0
```

# float型
浮動小数点型です。
```nix
3.1415926538
```

# bool型
`true`, `false`で宣言します
```nix
true
```

# list型
カンマなしで`[x1 x2 x3]`のように記述します。
```nix
[1 "a" true]
```

# attrset
他の言語でいうDict型です。
```nix
{a = 1; b = "x";}
```
# path型
String型とは別で評価された値がでる。
```nix
.int.nix
```
# lambda
関数型です。02-functionでじっくり解説します。

```nix
x : x + 1
```