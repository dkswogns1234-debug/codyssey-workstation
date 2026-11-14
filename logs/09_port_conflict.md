# 09_port_conflict.md

[← README로 돌아가기](../README.md)

포트 충돌을 일부러 만들고, 포트를 점유한 주체를 찾아 해제하는 과정의 실제 기록입니다. (Windows 11 + Git Bash + Docker Desktop)

## A. Docker 컨테이너끼리 같은 호스트 포트를 쓰려는 경우

```bash
$ date "+%F %T %Z"
2026-11-14 18:08:56    

$ docker start web-8080
web-8080

$ docker ps --format "{{.Names}}\t{{.Status}}\t{{.Ports}}"
web-8080	Up Less than a second (health: starting)	0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

$ docker run -d -p 8080:80 --name web-conflict codyssey-web:1.0
3f8e6acd59c57238f3e290b347d982a72d009020e7caea9a6d615ade70a1e12f
docker: Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint web-conflict (00dec24782a35e6e1de711bd92fc5b5c9f718853bd012f6180d342ccbf12f7f4): Bind for 0.0.0.0:8080 failed: port is already allocated

Run 'docker run --help' for more information

$ docker ps --filter "publish=8080" --format "{{.Names}} -> {{.Ports}}"
web-8080 -> 0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

$ netstat -ano | grep -E "[:.]8080 .*LISTENING"
  TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING       24124
  TCP    127.0.0.1:8080         0.0.0.0:0              LISTENING       8908
  TCP    [::]:8080              [::]:0                 LISTENING       24124
  TCP    [::1]:8080             [::]:0                 LISTENING       8908

```

### 점유 주체 확인 → 해제

```bash
$ tasklist /FI "PID eq 24124" /FO TABLE /NH

com.docker.backend.exe       24124 Console                    1    163,344 K

$ tasklist /FI "PID eq 8908" /FO TABLE /NH

wslrelay.exe                  8908 Console                    1     11,560 K

$ docker ps -a --filter "name=web-conflict" --format "{{.Names}}\t{{.Status}}"
web-conflict	Created

$ docker rm web-conflict
web-conflict

$ docker stop web-8080
web-8080

$ netstat -ano | grep -E "[:.]8080 .*LISTENING" || echo "8080 LISTEN 없음 (해제됨)"
  TCP    127.0.0.1:8080         0.0.0.0:0              LISTENING       8908
  TCP    [::1]:8080             [::]:0                 LISTENING       8908

$ docker run -d -p 8080:80 --name web-conflict codyssey-web:1.0
419094f85df8a681767c3626d917496c72816e020acc8c8446de9d27d5d4896f

$ # ※ 처음엔 시간 제한 없이 'until curl ...'로 기다렸다가, 컨테이너가 뜨는 중에 curl이 응답 대기에서 멈춤 → 중단(Ctrl+C) 후 -m 3(3초 제한)으로 다시 확인

$ curl -s -m 3 -o /dev/null -w "%{http_code}\n" http://localhost:8080
200

$ docker rm -f web-conflict
web-conflict

$ netstat -ano | grep -E "[:.]8080 .*LISTENING" || echo "8080 LISTEN 없음 (해제됨)"
  TCP    127.0.0.1:8080         0.0.0.0:0              LISTENING       8908
  TCP    [::1]:8080             [::]:0                 LISTENING       8908

```


## B. 다른 프로그램이 포트를 점유한 경우 → 점유 프로세스 찾아서 종료 (WSL Ubuntu)

리눅스에서는 같은 주소·포트에 공유 옵션(`SO_REUSEPORT` 등) 없이 두 번 바인딩하면 충돌하므로, 이 실험처럼 그대로 재현됩니다.

```bash
$ date "+%F %T %Z"
2026-11-14 18:15:18 KST

$ python3 -m http.server 8084 --bind 0.0.0.0 >/dev/null 2>&1 &  # 첫 번째 프로그램이 8084 점유

$ python3 -m http.server 8084 --bind 0.0.0.0 2>&1 | tail -1  # 같은 포트로 하나 더 → 충돌
OSError: [Errno 98] Address already in use

$ ss -ltnp "sport = :8084"  # 누가 8084를 LISTEN 중인지
State  Recv-Q Send-Q Local Address:Port Peer Address:PortProcess                          
LISTEN 0      5            0.0.0.0:8084      0.0.0.0:*    users:(("python3",pid=450,fd=3))

$ lsof -nP -iTCP:8084 -sTCP:LISTEN  # 같은 정보를 lsof로
COMMAND PID  USER FD   TYPE DEVICE SIZE/OFF NODE NAME
python3 450 dkswo 3u  IPv4  20084      0t0  TCP *:8084 (LISTEN)

$ PID=$(lsof -t -iTCP:8084 -sTCP:LISTEN -c python3); ps -o pid,cmd -p $PID; kill $PID; sleep 1; echo "kill $PID 완료"
    PID CMD
    450 python3 -m http.server 8084 --bind 0.0.0.0
kill 450 완료

$ ss -ltn "sport = :8084" | tail -n +2 | grep -q . || echo "8084 LISTEN 없음 (해제됨)"
8084 LISTEN 없음 (해제됨)

$ python3 -m http.server 8084 --bind 0.0.0.0 >/dev/null 2>&1 & sleep 1; curl -s -m 3 -o /dev/null -w "재시도 → HTTP %{http_code}\n" http://localhost:8084/
재시도 → HTTP 200

$ pkill -f "http.server 8084"; echo "정리 완료"
정리 완료

```

## C. (참고 관찰) Windows에서는 같은 포트가 충돌 없이 겹쳐질 수 있음

2026-11-14 실행. Windows에서 python이 8083을 먼저 LISTEN한 상태로 Docker가 같은 포트를 publish해도 오류가 나지 않았습니다. 이 경우 어느 쪽이 응답할지 보장되지 않으므로, 실행 전에 점유 여부를 먼저 확인합니다. (종료 대상은 tasklist로 python.exe임을 확인한 PID만 사용. `$TMPD`는 python이 내용을 공개하지 않도록 미리 만든 빈 임시 폴더)

```bash
$ python -m http.server 8083 --bind 0.0.0.0 --directory "$TMPD" >/dev/null 2>&1 &

$ docker run -d -p 8083:80 --name web-8083 codyssey-web:1.0 && echo "→ 오류 없이 실행됨"
f7555afc41c222aa93b5476aa2da6e5d190ca6aaa82c8abacb88e4b14d3c0533
→ 오류 없이 실행됨

$ netstat -ano | grep -E "0.0.0.0:8083 .*LISTENING"
  TCP    0.0.0.0:8083           0.0.0.0:0              LISTENING       24124
  TCP    0.0.0.0:8083           0.0.0.0:0              LISTENING       20584

$ for p in $(netstat -ano | grep -E "0.0.0.0:8083 .*LISTENING" | awk "{print \$5}" | sort -u); do tasklist /FI "PID eq $p" /FO TABLE /NH | grep -v "^$"; done
python.exe                   20584 Console                    1     24,956 K
com.docker.backend.exe       24124 Console                    1    165,408 K

$ docker rm -f web-8083
web-8083

$ for p in $(netstat -ano | grep -E "0.0.0.0:8083 .*LISTENING" | awk "{print \$5}" | sort -u); do if tasklist /FI "PID eq $p" /NH | grep -qi "^python.exe"; then taskkill /PID $p /F >/dev/null && echo "python.exe(PID $p) 종료"; fi; done
python.exe(PID 20584) 종료

$ netstat -ano | grep -E "[:.]8083 .*LISTENING" || echo "8083 LISTEN 없음 (정리됨)"
8083 LISTEN 없음 (정리됨)

```
