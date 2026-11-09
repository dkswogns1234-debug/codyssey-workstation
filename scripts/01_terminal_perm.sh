#!/usr/bin/env bash
# WSL Ubuntu에서 실행: 터미널 기본 조작 + 권한 실습 (명령과 출력을 로그로 기록)
PROJ="$(cd "$(dirname "$0")/.." && pwd)"
source "$PROJ/scripts/rec.sh" "$PROJ/logs/01_terminal.md"
: > "$LOG"
cd ~
r 'pwd'
r 'rm -rf ~/codyssey && mkdir -p ~/codyssey/practice'
r 'cd ~/codyssey/practice && pwd'
cd ~/codyssey/practice
r 'ls -la'
r 'touch empty.txt'
r 'echo "hello codyssey" > memo.txt'
r 'mkdir docs'
r 'ls -la'
r 'cat memo.txt'
r 'wc -c empty.txt'
r 'cp memo.txt docs/memo_copy.txt'
r 'mv empty.txt renamed.txt'
r 'mv renamed.txt docs/'
r 'ls -la . docs'
r 'cd docs && pwd && cd ..'
r 'cd ../practice/docs && pwd && cd ~/codyssey/practice'
r 'rm docs/renamed.txt'
r 'ls -la docs'
r 'echo ".hidden 파일" > .secret && ls && echo "--- ls -a ---" && ls -a'

source "$PROJ/scripts/rec.sh" "$PROJ/logs/02_permission.md"
: > "$LOG"
r 'mkdir -p perm_dir && touch perm_dir/a.txt && echo "data" > perm_file.txt'
echo "## 파일 권한: 644 → 755 → 600" >> "$LOG"
r 'ls -l perm_file.txt'
r 'stat -c "%A %a %n" perm_file.txt'
r 'chmod 755 perm_file.txt && ls -l perm_file.txt'
r 'chmod 600 perm_file.txt && ls -l perm_file.txt'
r 'chmod u=rw,g=r,o=r perm_file.txt && stat -c "%A %a %n" perm_file.txt'
echo "## 디렉토리 권한: 755 → 700 → 644(x 제거 시 진입 불가)" >> "$LOG"
r 'ls -ld perm_dir'
r 'chmod 700 perm_dir && ls -ld perm_dir'
r 'chmod 644 perm_dir && ls -ld perm_dir'
r 'cd perm_dir; echo "exit=$?"'
r 'ls -l perm_dir'
r 'chmod 755 perm_dir && ls -ld perm_dir && cd perm_dir && pwd && cd ..'
