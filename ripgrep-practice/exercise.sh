#!/usr/bin/env bash
#
# ripgrep (rg) Interactive Practice
# ==================================
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
SAMPLE_DIR="${SCRIPT_DIR}/sample"

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
if ! command -v rg &> /dev/null; then
    echo -e "${RED}Error: ripgrep (rg) がインストールされていません。${NC}"
    echo "  brew install ripgrep  または  nix-env -iA nixpkgs.ripgrep"
    exit 1
fi

if [[ ! -d "${SAMPLE_DIR}" ]]; then
    echo -e "${RED}Error: sample/ ディレクトリが見つかりません。${NC}"
    echo "  ${SAMPLE_DIR}"
    exit 1
fi

# --- Title ---
clear
echo ""
echo -e "${BOLD}${GREEN}========================================${NC}"
echo -e "${BOLD}${GREEN}   ripgrep (rg) Interactive Practice    ${NC}"
echo -e "${BOLD}${GREEN}========================================${NC}"
echo ""
echo -e "全 12 問の練習問題です。"
echo -e "各問題でヒントと回答を確認し、実際に自分でも試してみましょう。"
echo -e "検索対象: ${CYAN}${SAMPLE_DIR}${NC}"
echo ""
echo -e "${DIM}※ 自分で試す場合は別ターミナルで cd ${SCRIPT_DIR} してください${NC}"

wait_for_enter

# ========================================
# Q1: Basic search
# ========================================
show_question 1 "sample/ 以下から \"TODO\" を検索してみよう"
echo "  memo.md セクション: 1. 基本: パターン検索"
echo ""
show_hint "rg PATTERN PATH で特定ディレクトリを検索"
show_answer "rg TODO ${SAMPLE_DIR}"
run_answer "rg TODO ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q2: File type filter
# ========================================
show_question 2 "Python ファイルだけに絞って \"import\" を検索してみよう"
echo "  memo.md セクション: 3. ファイルタイプで絞り込み (-t / -T)"
echo ""
show_hint "-t py で Python ファイルだけに絞り込める"
show_answer "rg -t py 'import' ${SAMPLE_DIR}"
run_answer "rg -t py 'import' ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q3: Exclude test files
# ========================================
show_question 3 "テストファイルを除外して \"TODO\" を検索してみよう"
echo "  memo.md セクション: 4. glob パターンで絞り込み (-g)"
echo ""
show_hint "-g '!*test*' でテストファイルを除外できる"
show_answer "rg -g '!*test*' TODO ${SAMPLE_DIR}"
run_answer "rg -g '!*test*' TODO ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q4: Case insensitive search
# ========================================
show_question 4 "大文字小文字を無視して \"todo\" を検索してみよう"
echo "  memo.md セクション: 2. 大文字小文字"
echo ""
show_hint "-i で大文字小文字を無視できる"
show_answer "rg -i todo ${SAMPLE_DIR}"
run_answer "rg -i todo ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q5: Fixed string search
# ========================================
show_question 5 "\"user.name()\" をリテラル検索してみよう (正規表現ではなく)"
echo "  memo.md セクション: 6. 正規表現"
echo ""
echo "  普通に rg \"user.name()\" とすると . と () が正規表現として解釈される。"
echo "  -F を使うとリテラル文字列として検索できる。"
echo ""
show_hint "-F (--fixed-strings) で正規表現を無効化"
show_answer "rg -F 'user.name()' ${SAMPLE_DIR}"
run_answer "rg -F 'user.name()' ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q6: List matching files only
# ========================================
show_question 6 "TODO を含むファイル名だけ表示してみよう"
echo "  memo.md セクション: 7. ファイル名だけ表示 (-l / -L)"
echo ""
show_hint "-l でマッチしたファイル名だけ表示"
show_answer "rg -l TODO ${SAMPLE_DIR}"
run_answer "rg -l TODO ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q7: Count matches per file
# ========================================
show_question 7 "TODO の数をファイルごとにカウントしてみよう"
echo "  memo.md セクション: 8. マッチ数を表示 (-c)"
echo ""
show_hint "-c でファイルごとのマッチ数を表示"
show_answer "rg -c TODO ${SAMPLE_DIR}"
run_answer "rg -c TODO ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q8: Context lines
# ========================================
show_question 8 "\"def\" を含む行の前後 2 行を表示してみよう"
echo "  memo.md セクション: 5. コンテキスト表示 (-A / -B / -C)"
echo ""
show_hint "-C 2 でマッチ行の前後 2 行を表示"
show_answer "rg -C 2 'def ' ${SAMPLE_DIR}"
run_answer "rg -C 2 'def ' ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q9: Search hidden files
# ========================================
show_question 9 "隠しファイル (.env.example) も含めて \"TODO\" を検索してみよう"
echo "  memo.md セクション: 10. 隠しファイル・gitignore 無視ファイルも検索"
echo ""
echo "  rg はデフォルトで隠しファイル (ドットで始まるファイル) をスキップする。"
echo "  まず --hidden なしで検索し、次に --hidden 付きで検索して違いを確認しよう。"
echo ""
show_hint "--hidden で隠しファイルも検索対象に含める"
echo ""
echo -e "  ${GREEN}Without --hidden:${NC}"
echo -e "  ${CYAN}\$ rg -l TODO ${SAMPLE_DIR}${NC}"
run_answer "rg -l TODO ${SAMPLE_DIR}"
echo ""
echo -e "  ${GREEN}With --hidden:${NC}"
echo -e "  ${CYAN}\$ rg --hidden -l TODO ${SAMPLE_DIR}${NC}"
run_answer "rg --hidden -l TODO ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q10: Multiline search
# ========================================
show_question 10 "複数行にまたがる struct 定義を検索してみよう"
echo "  memo.md セクション: 11. マルチライン検索 (-U)"
echo ""
echo "  -U で複数行にまたがるパターンを検索できる。"
echo "  struct 名の後に { があり、その中に name フィールドがあるパターンを検索。"
echo ""
show_hint "-U (--multiline) で改行をまたぐ検索ができる"
show_answer "rg -U 'struct \w+\s*\{[^}]*name' ${SAMPLE_DIR}"
run_answer "rg -U 'struct \w+\s*\{[^}]*name' ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q11: FIXME/HACK comments
# ========================================
show_question 11 "FIXME や HACK コメントを一括検索してみよう"
echo "  memo.md セクション: 6. 正規表現"
echo ""
echo "  正規表現の | (OR) を使って複数パターンを同時に検索できる。"
echo "  コードレビューやリファクタリング前に問題のあるコードを見つけるのに便利。"
echo ""
show_hint "パターンに | を使って OR 検索"
show_answer "rg 'FIXME|HACK' ${SAMPLE_DIR}"
run_answer "rg 'FIXME|HACK' ${SAMPLE_DIR}"

wait_for_enter

# ========================================
# Q12: Smart case
# ========================================
show_question 12 "スマートケースで \"todo\" と \"TODO\" の違いを確認してみよう"
echo "  memo.md セクション: 2. 大文字小文字"
echo ""
echo "  -S (--smart-case):"
echo "    パターンが全部小文字 -> case-insensitive (大文字小文字を無視)"
echo "    パターンに大文字を含む -> case-sensitive (大文字小文字を区別)"
echo ""
show_hint "-S でスマートケースを有効化"
echo ""
echo -e "  ${GREEN}rg -S todo (全部小文字 -> case-insensitive):${NC}"
echo -e "  ${CYAN}\$ rg -S todo ${SAMPLE_DIR}${NC}"
run_answer "rg -S todo ${SAMPLE_DIR}"
echo ""
echo -e "  ${GREEN}rg -S TODO (大文字含む -> case-sensitive):${NC}"
echo -e "  ${CYAN}\$ rg -S TODO ${SAMPLE_DIR}${NC}"
run_answer "rg -S TODO ${SAMPLE_DIR}"

# ========================================
# Finish
# ========================================
separator
echo -e "${BOLD}${GREEN}All 12 exercises completed!${NC}"
echo ""
echo "次のステップ:"
echo "  - 別ターミナルで cd ${SCRIPT_DIR} して自分で rg コマンドを試す"
echo "  - memo.md の他のオプションも試してみる (--json, fzf 連携など)"
echo "  - rg --help で全オプションを確認する"
echo ""
