x, u,c, S, s, m, hがよくわからんgit reset , git checkout -- . git clean -fdなんだの
思考時間: 3m 42s

lazygitのその辺のキー、「どのパネル（Files/Commits/Branches…）にいるか」で意味が変わるのが混乱ポイント。
なのでまず大前提として、その場で ? を押すと「今の画面で効くキー」が出る（これがいちばん確実）。

そのうえで、あなたが挙げた x, u, c, S, s, m, h を “よく遭遇する文脈” で整理するね。

lazygitのキー → だいたい何のgit操作？
x：メニュー（その場の操作一覧）

x は「メニューを開く」＝その画面でできる操作がまとまって出るやつ。
（gitコマンド1個に対応というより “ランチャー”）

c：Commit（主に Files パネルで）

Filesパネルだと c は “ステージ済みをcommit”。
対応するのは基本 git commit（ステージ内容が対象）

※Commitsパネルの c は別の意味（fixup message設定など）もあるので、ここは「今どのパネルか」が超重要。

s / S：Stash（Filesパネル）

s：全部stash（変更を一時退避）

S：stashの詳細オプション（stagedだけ/unstagedだけ等）

対応するのはだいたい git stash push ... 系。

m：merge/rebase の abort/continue/skip

m は merge/rebaseの状態操作メニュー（abort/continue/skip）。
対応するのは例として：

git rebase --abort / --continue / --skip

git merge --abort など

u：Upstream（Branches/Remotesで）

u は “undo” じゃなくて upstream（追跡ブランチ）関連のメニュー。
たとえば「upstreamの設定/解除」「upstreamへreset」など。

h / m / s が出てくるやつ：Resetの種類（soft/mixed/hard）

ここがたぶん一番「git reset何者…」ってなるところ。

lazygitだと Commits パネルで g を押すと resetメニュー（soft/mixed/hard） が出る。
そのポップアップに m/s/h のヒントが表示されることがあって（mixed/soft/hardのショートカット的なやつ）、それを押して選ぶ流れ。

ただ、環境/バージョン/選んだコミット次第で「キー押しても反応しない」「Enterでも動かない」って人が一定いて、
“resetしたい先のコミットを選べてない” 勘違いが原因だった例がある（「消したいコミット」ではなく「戻したい先」を選ぶ）。

じゃあ git reset / git checkout -- . / git clean -fd は何？

Gitはざっくり 3つの層 があると思うと一気に分かれる：

HEAD：今のコミット（履歴の先端）

Index（staging）：次にcommitする内容

Working tree：作業中のファイル（未ステージ含む）

git reset：HEADとIndex（と場合によってWorking tree）をいじる

soft：HEADだけ動かす（Index/作業ツリーはそのまま）
→ 「commit取り消したいけど、変更は全部ステージ済みにしておきたい」

mixed（デフォルト）：HEAD＋Indexを戻す（作業ツリーは残る）
→ 「commit取り消して、変更は“未ステージ”に戻したい」

hard：HEAD＋Index＋作業ツリー全部戻す（未コミット変更が消える）
→ 「全部捨ててその時点に戻る（危険）」

lazygitの reset（soft/mixed/hard）もこの概念そのまま。

git checkout -- .：作業ツリーの“trackedファイル”を元に戻す

これは tracked（git管理下）の変更を捨てる系。
実体は「作業ツリーをIndexの内容で上書き」なので、ステージ済み変更がある場合は HEADじゃなくてIndexの状態 に戻る点がクセ。

（いまどきは git restore . が後継）

git clean -fd：untracked（git管理外）を消す

-f：強制（これがないと消えない）

-d：ディレクトリも消す

つまり 未追跡ファイル/フォルダを掃除するコマンド。
危ないので、実行前はこれ推奨：

git clean -nd   # 何が消えるかプレビュー

lazygitで「全部戻す/掃除する」に近い操作は？

Filesパネルには

d：そのファイルの変更を捨てる（discard options）

D：作業ツリーをresetする（“nuking the working tree” みたいな強いの含む）

があって、ここがだいたい

trackedの変更を捨てる（git checkout -- <file> / git restore <file> 相当）

untrackedを消す（git clean -fd 相当）

まとめて全消し（git reset --hard + git clean -fd 方向）

の入口になりがち。

迷子にならない使い分け（超短い結論）

とりあえず退避：Filesで s（stash）

rebase/mergeをやめる：m → abort

コミットを戻したい：Commitsで g → soft/mixed/hard（戻したい“先”を選ぶ）

未追跡のゴミ掃除：git clean -nd で確認してから -fd