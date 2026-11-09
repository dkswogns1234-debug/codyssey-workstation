# 사용법: source scripts/rec.sh logs/파일.md  →  r '명령'  (명령과 출력을 로그에 함께 기록)
LOG="$1"
r() { { echo "\$ $*"; eval "$*" 2>&1; echo; } | tee -a "$LOG"; }
