#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --- Helper functions ---
separator() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
}

wait_for_enter() {
    echo ""
    echo -e "${YELLOW}  Press Enter to see the answer...${RESET}"
    read -r
}

show_hint() {
    echo -e "${YELLOW}  Hint: $1${RESET}"
}

show_answer() {
    echo -e "${GREEN}  Answer: ${BOLD}$1${RESET}"
}

run_answer() {
    echo ""
    echo -e "${GREEN}  Result:${RESET}"
    eval "$1" 2>&1 | sed 's/^/    /'
}

wait_for_try() {
    echo ""
    echo -e "${YELLOW}  Try it yourself first, then press Enter to see the result...${RESET}"
    read -r
}

# --- Pre-check ---
PID_FILE="/tmp/pgrep-practice-pids.txt"
if [[ ! -f "$PID_FILE" ]]; then
    echo -e "${RED}Error: Practice processes are not running.${RESET}"
    echo "Run ./setup.sh first!"
    exit 1
fi

# Verify at least some processes are still alive
alive=0
while IFS= read -r pid; do
    kill -0 "$pid" 2>/dev/null && ((alive++))
done < "$PID_FILE"

if [[ $alive -eq 0 ]]; then
    echo -e "${RED}Error: All practice processes have died.${RESET}"
    echo "Run ./setup.sh again!"
    exit 1
fi

# --- Start ---
echo ""
echo -e "${BOLD}=== pgrep Practice Exercises ===${RESET}"
echo ""
echo "Practice processes are running ($alive alive)."
echo "Open another terminal to try the commands yourself!"
echo ""
echo -e "Tip: ${CYAN}pgrep --help${RESET} or ${CYAN}man pgrep${RESET} for reference."
echo ""
echo -e "${YELLOW}Press Enter to start...${RESET}"
read -r

########################################
# Q1
########################################
separator
echo -e "${BOLD}Q1: worker という名前を含むプロセスを探してみよう${RESET}"
echo ""
echo "  \"worker\" を名前に含むプロセスの PID を全て表示してください。"
echo ""
show_hint "pgrep はデフォルトで部分一致検索をします"

wait_for_try

show_answer "pgrep -f worker"
run_answer "pgrep -f worker || echo '(no matches)'"

echo ""
echo -e "  ${CYAN}Note: -f はコマンドライン全体を検索します。"
echo -e "  -f なしだとプロセス名のみで検索します。${RESET}"
echo ""
echo -e "  ${CYAN}pgrep -l -f worker とすると名前も表示されます:${RESET}"
run_answer "pgrep -l -f worker || echo '(no matches)'"

########################################
# Q2
########################################
separator
echo -e "${BOLD}Q2: worker-alpha だけを完全一致で探してみよう${RESET}"
echo ""
echo "  worker-alpha というプロセスだけを探して PID を取得してください。"
echo "  worker-beta や worker-gamma はヒットしないこと。"
echo ""
show_hint "完全一致には -x オプションを使います"

wait_for_try

show_answer "pgrep -x worker-alpha"
run_answer "pgrep -x worker-alpha || echo '(no matches)'"

echo ""
echo -e "  ${CYAN}確認: -x なしだと部分一致なので他もヒットする可能性があります。"
echo -e "  比較してみましょう:${RESET}"
echo -e "  ${CYAN}pgrep -l worker-alpha (部分一致):${RESET}"
run_answer "pgrep -l worker-alpha || echo '(no matches)'"
echo -e "  ${CYAN}pgrep -x -l worker-alpha (完全一致):${RESET}"
run_answer "pgrep -x -l worker-alpha || echo '(no matches)'"

########################################
# Q3
########################################
separator
echo -e "${BOLD}Q3: 自分のユーザーの python3 プロセスを探してみよう${RESET}"
echo ""
echo "  自分のユーザー ($(whoami)) が実行している python3 プロセスを探してください。"
echo ""
show_hint "ユーザー指定には -u オプションを使います"

wait_for_try

show_answer "pgrep -u \$(whoami) -x python3"
run_answer "pgrep -u $(whoami) -x python3 || echo '(no matches)'"

echo ""
echo -e "  ${CYAN}別のユーザーのプロセスだけ探す場合:${RESET}"
echo -e "  ${CYAN}pgrep -u root -l python3 (root ユーザーの python3)${RESET}"
run_answer "pgrep -u root -l python3 || echo '(no matches -- root has no python3)'"

########################################
# Q4
########################################
separator
echo -e "${BOLD}Q4: worker プロセスが何個あるか数えてみよう${RESET}"
echo ""
echo "  worker という名前を含むプロセスの数を表示してください。"
echo ""
show_hint "pgrep -c でカウントできます"

wait_for_try

show_answer "pgrep -c -f worker"
run_answer "pgrep -c -f worker || echo '0'"

echo ""
echo -e "  ${CYAN}Note: -c (count) は一致したプロセスの数を返します。"
echo -e "  スクリプトでプロセスの存在チェックに便利です:${RESET}"
echo -e "  ${CYAN}  if pgrep -f worker > /dev/null; then echo 'running'; fi${RESET}"

########################################
# Q5
########################################
separator
echo -e "${BOLD}Q5: 最も新しい worker プロセスの PID を取得してみよう${RESET}"
echo ""
echo "  worker を含むプロセスのうち、最も最近起動されたものの PID だけ取得してください。"
echo ""
show_hint "最新のプロセスを取得するオプションがあります"

wait_for_try

show_answer "pgrep -n -f worker"
run_answer "pgrep -n -f worker || echo '(no matches)'"

echo ""
echo -e "  ${CYAN}逆に、最も古いプロセスは -o で取得できます:${RESET}"
echo -e "  ${CYAN}pgrep -o -f worker:${RESET}"
run_answer "pgrep -o -f worker || echo '(no matches)'"

echo ""
echo -e "  ${CYAN}-n = newest, -o = oldest と覚えましょう。${RESET}"

########################################
# Q6
########################################
separator
echo -e "${BOLD}Q6: worker プロセスの PID をカンマ区切りで取得してみよう${RESET}"
echo ""
echo "  worker を含むプロセスの PID を 1234,5678,9012 のようにカンマ区切りで出力してください。"
echo ""
show_hint "出力の区切り文字を変えるオプションがあります"

wait_for_try

show_answer "pgrep -d ',' -f worker"
run_answer "pgrep -d ',' -f worker || echo '(no matches)'"

echo ""
echo -e "  ${CYAN}Note: -d (delimiter) で区切り文字を指定できます。"
echo -e "  デフォルトは改行です。${RESET}"
echo ""
echo -e "  ${CYAN}応用: kill \$(pgrep -d ' ' -f worker) のように組み合わせることもできます。${RESET}"

########################################
# Q7
########################################
separator
echo -e "${BOLD}Q7: pkill で worker-gamma だけ止めてみよう${RESET}"
echo ""
echo "  pkill を使って worker-gamma プロセスだけを終了させてください。"
echo "  他の worker プロセスは残すこと。"
echo ""
show_hint "pkill は pgrep と同じパターンマッチでプロセスを kill します。完全一致には -x を使います。"

echo ""
echo -e "  ${CYAN}まず、現在の worker プロセスを確認:${RESET}"
run_answer "pgrep -l -f worker || echo '(no matches)'"

wait_for_try

show_answer "pkill -x worker-gamma"
echo ""
echo -e "${YELLOW}  実行しますか? (y/N)${RESET}"
read -r yn
if [[ "$yn" =~ ^[Yy]$ ]]; then
    if pkill -x worker-gamma 2>/dev/null; then
        echo -e "  ${GREEN}worker-gamma を停止しました!${RESET}"
    else
        echo -e "  ${RED}worker-gamma は既に停止しているか見つかりませんでした。${RESET}"
    fi
    echo ""
    echo -e "  ${CYAN}残っている worker プロセス:${RESET}"
    run_answer "pgrep -l -f worker || echo '(no matches)'"
else
    echo -e "  ${CYAN}スキップしました。自分で試してみてください:${RESET}"
    echo -e "  ${GREEN}  pkill -x worker-gamma${RESET}"
fi

########################################
# Done
########################################
separator
echo -e "${BOLD}=== Exercise Complete! ===${RESET}"
echo ""
echo "Summary of pgrep/pkill options:"
echo ""
echo -e "  ${CYAN}pgrep${RESET} - プロセスを検索して PID を表示"
echo -e "    -f        コマンドライン全体で検索 (フルマッチ)"
echo -e "    -l        PID と一緒にプロセス名も表示"
echo -e "    -x        プロセス名の完全一致"
echo -e "    -u USER   指定ユーザーのプロセスのみ"
echo -e "    -c        マッチしたプロセスの数を表示"
echo -e "    -n        最も新しいプロセスのみ"
echo -e "    -o        最も古いプロセスのみ"
echo -e "    -d DELIM  区切り文字を指定"
echo ""
echo -e "  ${CYAN}pkill${RESET} - プロセスを検索して kill"
echo -e "    pgrep と同じオプションが使えます"
echo -e "    -SIGNAL   送るシグナルを指定 (例: -9, -HUP)"
echo ""
echo -e "Don't forget to run ${BOLD}./teardown.sh${RESET} when you're done!"
echo ""
