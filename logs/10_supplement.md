# 10_supplement.md

[← README로 돌아가기](../README.md)

사전평가 보완 의견을 반영해 추가로 실행한 기록입니다. (Windows 11 + Git Bash + Docker Desktop)

```bash
$ date "+%F %T"
2026-11-14 18:16:01

$ docker run --name hello-check hello-world | head -3

Hello from Docker!
This message shows that your installation appears to be working correctly.

$ docker ps -a --filter "name=hello-check" --format "table {{.ID}}\t{{.Image}}\t{{.Command}}\t{{.CreatedAt}}\t{{.Status}}"
CONTAINER ID   IMAGE         COMMAND    CREATED AT                      STATUS
2323ef8abc94   hello-world   "/hello"   2026-11-14 18:16:02 +0900 KST   Exited (0) Less than a second ago

$ docker rm hello-check
hello-check

$ docker images --format "table {{.Repository}}:{{.Tag}}\t{{.ID}}\t{{.CreatedSince}}"
REPOSITORY:TAG       IMAGE ID       CREATED
codyssey-web:1.0     50273fab5627   4 days ago
ubuntu:24.04         fe81560990fa   2 weeks ago
alpine:3.20          d9e853e87e55   7 months ago
hello-world:latest   c567b231f656   7 months ago
nginx:1.27-alpine    65645c7bb6a0   19 months ago

$ docker image inspect codyssey-web:1.0 --format "Tags={{.RepoTags}}  ID={{.Id}}"
Tags=[codyssey-web:1.0]  ID=sha256:50273fab5627eb4a313fee9c4d942a8f43d61e0d18bbe9456054c057ff066afe

$ docker image inspect codyssey-web:1.0 --format "Env={{.Config.Env}}"
Env=[PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin NGINX_VERSION=1.27.5 PKG_RELEASE=1 DYNPKG_RELEASE=1 NJS_VERSION=0.8.10 NJS_RELEASE=1 APP_ENV=dev]

$ docker image inspect codyssey-web:1.0 --format "ExposedPorts={{.Config.ExposedPorts}}  Labels={{.Config.Labels}}"
ExposedPorts=map[80/tcp:{}]  Labels=map[maintainer:NGINX Docker Maintainers <docker-maint@nginx.com> org.opencontainers.image.description:Codyssey dev workstation custom nginx org.opencontainers.image.title:codyssey-web]

```

### 이미지 vs 컨테이너: 컨테이너 안에서 바꾼 내용은 이미지에 남지 않는다

```bash
$ docker run -d --name layer-demo codyssey-web:1.0
6d5af132e66da38748de64b873e0fc92a379eb61a4a3ea52fcae860e84e77f6b

$ docker exec layer-demo sh -c "echo changed-in-container > /usr/share/nginx/html/index.html; cat /usr/share/nginx/html/index.html"
changed-in-container

$ docker rm -f layer-demo
layer-demo

$ docker run --rm codyssey-web:1.0 grep -o "<h1>.*</h1>" /usr/share/nginx/html/index.html
<h1>Hello, Codyssey! 🐳</h1>

```

### Docker 데몬 재점검 (2026-11-14, 이번 보완 작업 시작 시)

Docker Desktop이 꺼진 상태에서 시작해 트러블슈팅 1과 같은 증상이 다시 나왔고, 앱 실행 후 5초 간격 확인 첫 회에 복구됐습니다.

```bash
$ docker info --format '{{.ServerVersion}}'
failed to connect to the docker API at npipe:////./pipe/dockerDesktopLinuxEngine; check if the path is correct and if the daemon is running: open //./pipe/dockerDesktopLinuxEngine: The system cannot find the file specified.

$ # Docker Desktop 실행 후 5초 간격으로 docker info 재확인
$ for i in $(seq 1 60); do docker info --format '{{.ServerVersion}}' >/dev/null 2>&1 && { echo "ready after ${i}x5s: $(docker info --format '{{.ServerVersion}}')"; break; }; sleep 5; done
ready after 1x5s: 29.9.3
```

### Git 이력 (2026-11-14, 보완 커밋 직전)

```bash
$ git log --oneline -3
e7fe77d README 경로 예시 수정: 실습 로그와 같게 cd .. 추가
3e7985d 스크린샷(브라우저 접속, GitHub 저장소) 추가 및 GitHub 연동 기록
d96dc63 개발 워크스테이션 미션: 터미널/권한/Docker/Dockerfile/포트/마운트/볼륨/Compose 실습 및 기술 문서

$ git status -sb | head -1
## main...origin/main

```

## 2차 보완 (2026-11-14, 사전평가 100% 이후 보완 의견 반영)

### 볼륨 권한·소유권 확인 (#8)

```bash
$ date "+%F %T"
2026-11-14 18:28:33

$ docker volume inspect codyssey-data --format "Mountpoint={{.Mountpoint}}"
Mountpoint=/var/lib/docker/volumes/codyssey-data/_data

$ docker run --rm -v codyssey-data:/data ubuntu:24.04 ls -ld /data
drwxr-xr-x 2 root root 4096 Nov  9 11:25 /data

$ docker run --rm -v codyssey-data:/data ubuntu:24.04 ls -ln /data
total 4
-rw-r--r-- 1 0 0 34 Nov  9 11:25 hello.txt

$ docker run --rm --user 1000:1000 -v codyssey-data:/data ubuntu:24.04 sh -c "touch /data/by-uid1000.txt" ; echo "exit=$?"
touch: cannot touch '/data/by-uid1000.txt': Permission denied
exit=1

$ docker run --rm -v codyssey-data:/data ubuntu:24.04 chown 1000:1000 /data  # 해결: 볼륨 디렉토리 소유자를 컨테이너 사용자로

$ docker run --rm --user 1000:1000 -v codyssey-data:/data ubuntu:24.04 sh -c "touch /data/by-uid1000.txt && ls -ln /data"
total 4
-rw-r--r-- 1 1000 1000  0 Nov 14 09:29 by-uid1000.txt
-rw-r--r-- 1    0    0 34 Nov  9 11:25 hello.txt

$ docker run --rm -v codyssey-data:/data ubuntu:24.04 sh -c "rm /data/by-uid1000.txt && chown 0:0 /data && ls -ld /data"  # 실습 후 원래 상태로 복구
drwxr-xr-x 2 root root 4096 Nov 14 09:29 /data

```

### 네트워크 모드 비교: bridge vs none (#13)

```bash
$ docker run --rm alpine:3.20 ip -4 -o addr show
1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever
2: eth0    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0\       valid_lft forever preferred_lft forever

$ docker run --rm --network none alpine:3.20 ip -4 -o addr show
1: lo    inet 127.0.0.1/8 scope host lo\       valid_lft forever preferred_lft forever

$ docker run --rm --network none alpine:3.20 wget -q -T 3 -O /dev/null http://example.com ; echo "exit=$?"
wget: bad address 'example.com'
exit=1

```

### 권한 숫자 읽기 예시 (#15, WSL Ubuntu)

```bash
$ touch read_demo.txt && mkdir -p team_dir

$ chmod 640 read_demo.txt && stat -c "%A %a %n" read_demo.txt  # 6=rw-(나) 4=r--(그룹) 0=---(기타): 팀원만 읽는 설정 파일
-rw-r----- 640 read_demo.txt

$ chmod 750 team_dir && stat -c "%A %a %n" team_dir  # 7=rwx 5=r-x 0=---: 그룹은 들어가 읽기만, 기타는 접근 불가
drwxr-x--- 750 team_dir

$ ls -ld /tmp  # 맨 끝 t = sticky bit(1777): 누구나 쓰지만 남의 파일은 못 지움
drwxrwxrwt 8 root root 160 Nov 14 18:29 /tmp

$ rm -r read_demo.txt team_dir

```

### 데몬 빠른 점검 3개 · 원격 상태 (2026-11-14)

```bash
$ date "+%F %T"
2026-11-14 18:33:42

$ docker version --format '{{.Server.Version}}'
29.9.3

$ docker info --format '{{.ServerVersion}}'
29.9.3

$ wsl -l -v | tr -d "\000" | grep -E "NAME|docker-desktop"
  NAME              STATE           VERSION
  docker-desktop    Running         2

$ git fetch -q origin && git log --oneline -1 origin/main
5d7208d 사전평가 보완: 포트 충돌 진단·해제 절차 문서화 및 항목별 보완

```
