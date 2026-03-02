#!/usr/bin/env bash
#
# fd Interactive Practice
# =======================
# memo.md の内容を実際に試すためのインタラクティブ練習問題集
#
# 使い方: ./exercise.sh
# 各問題で Enter を押すと次に進みます。

set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# --- Helpers ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

separator() {
    echo ""
    echo -e "${DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

wait_for_enter() {
    echo ""
    echo -e "${DIM}Enter を押して次へ...${NC}"
    read -r
}

show_question() {
    local num="$1"
    local title="$2"
    separator
    echo -e "${BOLD}${BLUE}Q${num}: ${title}${NC}"
    echo ""
}

show_hint() {
    echo -e "  ${YELLOW}Hint:${NC} $1"
}

show_answer() {
    echo -e "  ${GREEN}Answer:${NC}"
    echo -e "  ${CYAN}\$ $1${NC}"
}

run_answer() {
    echo ""
    echo -e "  ${GREEN}Result:${NC}"
    echo ""
    eval "$1" 2>&1 | sed 's/^/    /'
}

# --- Pre-flight check ---
if ! command -v fd &> /dev/null; then
    echo -e "${RED}Error: fd がインストールされていません。${NC}"
    echo "  brew install fd  または  nix-env -iA nixpkgs.fd"
    exit 1
fi

if [[ ! -d "${SCRIPT_DIR}/src" ]]; then
    echo -e "${RED}Error: src/ ディレクトリが見つかりません。${NC}"
    echo "  ${SCRIPT_DIR}/src"
    exit 1
fi

# --- Title ---
clear
echo ""
echo -e "${BOLD}${GREEN}========================================${NC}"
echo -e "${BOLD}${GREEN}      fd Interactive Practice           ${NC}"
echo -e "${BOLD}${GREEN}========================================${NC}"
echo ""
echo -e "全 12 問の練習問題です。"
echo -e "各問題でヒントと回答を確認し、実際に自分でも試してみましょう。"
echo -e "検索対象: ${CYAN}${SCRIPT_DIR}${NC}"
echo ""
echo -e "${DIM}※ 自分で試す場合は別ターミナルで cd ${SCRIPT_DIR} してください${NC}"

wait_for_enter

# ========================================
# Q1: Basic search
# ========================================
show_question 1 "\"memo\" を含むファイルを検索してみよう"
echo "  memo.md セクション: 2. 基本: ファイル名で検索"
echo ""
show_hint "fd PATTERN でカレントディレクトリ以下を検索"
show_answer "fd memo ${SCRIPT_DIR}"
run_answer "fd memo ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q2: Extension filter
# ========================================
show_question 2 "TypeScript (.ts) ファイルだけを検索してみよう"
echo "  memo.md セクション: 3. 拡張子で絞り込む (-e)"
echo ""
show_hint "-e EXT で拡張子を指定して検索"
show_answer "fd -e ts ${SCRIPT_DIR}"
run_answer "fd -e ts ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q3: Directory only
# ========================================
show_question 3 "ディレクトリだけを一覧表示してみよう"
echo "  memo.md セクション: 4. ファイルタイプで絞り込む (-t)"
echo ""
show_hint "-t d でディレクトリだけに絞り込める"
show_answer "fd -t d ${SCRIPT_DIR}"
run_answer "fd -t d ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q4: Hidden files
# ========================================
show_question 4 "隠しファイル (ドットファイル) を検索してみよう"
echo "  memo.md セクション: 5. 隠しファイル・無視ファイルの扱い (-H / -I)"
echo ""
echo "  fd はデフォルトで隠しファイルをスキップする。"
echo "  -H を付けると隠しファイルも検索対象になる。"
echo ""
show_hint "-H で隠しファイルを含め、'^\\.' でドットから始まるファイルを検索"
echo ""
echo -e "  ${GREEN}Without -H (隠しファイルなし):${NC}"
echo -e "  ${CYAN}\$ fd '^\\\.' ${SCRIPT_DIR}${NC}"
run_answer "fd '^\.' ${SCRIPT_DIR}"
echo ""
echo -e "  ${GREEN}With -H (隠しファイルあり):${NC}"
echo -e "  ${CYAN}\$ fd -H '^\\\.' ${SCRIPT_DIR}${NC}"
run_answer "fd -H '^\.' ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q5: Search gitignored files
# ========================================
show_question 5 ".gitignore で無視されたログファイルを検索してみよう"
echo "  memo.md セクション: 5. 隠しファイル・無視ファイルの扱い (-H / -I)"
echo ""
echo "  .gitignore に *.log が含まれているため、デフォルトではログファイルは見えない。"
echo "  -I を付けると .gitignore を無視して検索できる。"
echo ""
show_hint "-I で gitignore 対象も検索し、-e log でログファイルに絞る"
echo ""
echo -e "  ${GREEN}Without -I (gitignore 対象は除外):${NC}"
echo -e "  ${CYAN}\$ fd -e log ${SCRIPT_DIR}${NC}"
run_answer "fd -e log ${SCRIPT_DIR} || echo '    (結果なし)'"
echo ""
echo -e "  ${GREEN}With -I (gitignore 無視):${NC}"
echo -e "  ${CYAN}\$ fd -I -e log ${SCRIPT_DIR}${NC}"
run_answer "fd -I -e log ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q6: Depth limit
# ========================================
show_question 6 "深度 2 以内の Markdown ファイルだけ検索してみよう"
echo "  memo.md セクション: 6. 検索深度の制限 (-d)"
echo ""
show_hint "-d 2 で最大2階層に制限、-e md でマークダウンに絞る"
show_answer "fd -d 2 -e md ${SCRIPT_DIR}"
run_answer "fd -d 2 -e md ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q7: Glob pattern
# ========================================
show_question 7 "テストファイル (*.test.* または *.spec.*) をグロブで検索してみよう"
echo "  memo.md セクション: 7. グロブパターン (-g)"
echo ""
echo "  -g を使うと正規表現ではなくグロブパターンで検索できる。"
echo ""
show_hint "-g 'PATTERN' でグロブモード検索"
show_answer "fd -g '*.test.*' ${SCRIPT_DIR}"
run_answer "fd -g '*.test.*' ${SCRIPT_DIR}"
echo ""
echo -e "  ${DIM}※ spec ファイルも試してみよう: fd -g '*.spec.*' ${SCRIPT_DIR}${NC}"

wait_for_enter

# ========================================
# Q8: Symlinks
# ========================================
show_question 8 "シンボリックリンクだけを検索してみよう"
echo "  memo.md セクション: 4. ファイルタイプで絞り込む (-t)"
echo ""
show_hint "-t l でシンボリックリンクだけに絞り込める"
show_answer "fd -t l ${SCRIPT_DIR}"
run_answer "fd -t l ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q9: Empty files
# ========================================
show_question 9 "空ファイルを検索してみよう"
echo "  memo.md セクション: 4. ファイルタイプで絞り込む (-t)"
echo ""
echo "  -t e で空のファイルやディレクトリを検索できる。"
echo ""
show_hint "-t e で空ファイルを検索"
show_answer "fd -t e ${SCRIPT_DIR}"
run_answer "fd -t e ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q10: Size filter
# ========================================
show_question 10 "1MB 以上のファイルを検索してみよう"
echo "  memo.md セクション: 12. サイズ・更新日時で絞り込む (-S / --changed-within)"
echo ""
echo "  -S +1m で 1MB 以上のファイルを検索できる。"
echo "  ※ -I を付けて gitignore 対象（ログファイル）も含める必要がある。"
echo ""
show_hint "-S +1m でサイズフィルタ、-I で gitignore 無視"
show_answer "fd -I -S +1m ${SCRIPT_DIR}"
run_answer "fd -I -S +1m ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q11: Exclude pattern
# ========================================
show_question 11 "node_modules を除外して JavaScript ファイルを検索してみよう"
echo "  memo.md セクション: 10. 除外パターン (-E)"
echo ""
echo "  デフォルトでは .gitignore で node_modules は除外されるが、"
echo "  -I を付けた場合は -E で明示的に除外する必要がある。"
echo ""
show_hint "-E PATTERN で特定のパスを除外"
echo ""
echo -e "  ${GREEN}With -I (node_modules も見える):${NC}"
echo -e "  ${CYAN}\$ fd -I -e js ${SCRIPT_DIR}${NC}"
run_answer "fd -I -e js ${SCRIPT_DIR}"
echo ""
echo -e "  ${GREEN}With -I -E node_modules (除外):${NC}"
echo -e "  ${CYAN}\$ fd -I -E node_modules -e js ${SCRIPT_DIR}${NC}"
run_answer "fd -I -E node_modules -e js ${SCRIPT_DIR}"

wait_for_enter

# ========================================
# Q12: Execute command
# ========================================
show_question 12 "TypeScript ファイルそれぞれの行数を数えてみよう"
echo "  memo.md セクション: 11. コマンド実行 (-x / -X)"
echo ""
echo "  -x で見つかったファイルそれぞれにコマンドを実行できる。"
echo "  {} はファイルパスのプレースホルダ。"
echo ""
echo -e "  ${YELLOW}⚠️ zsh では {} を必ずクォートすること${NC}"
echo ""
show_hint "-x CMD '{}' で各ファイルにコマンド実行"
show_answer "fd -e ts ${SCRIPT_DIR} -x wc -l '{}'"
run_answer "fd -e ts ${SCRIPT_DIR} -x wc -l '{}'"

# ========================================
# Finish
# ========================================
separator
echo -e "${BOLD}${GREEN}All 12 exercises completed!${NC}"
echo ""
echo "次のステップ:"
echo "  - 別ターミナルで cd ${SCRIPT_DIR} して自分で fd コマンドを試す"
echo "  - memo.md の他のオプションも試してみる (--changed-within, -p, fzf 連携など)"
echo "  - fd --help で全オプションを確認する"
echo ""
