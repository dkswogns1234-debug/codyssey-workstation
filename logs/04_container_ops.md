# 04_container_ops.md

[← README로 돌아가기](../README.md)

## exec vs attach 관찰

```bash
$ docker run -d --name ubu ubuntu:24.04 bash -c "i=0; while true; do echo tick \$i; i=\$((i+1)); sleep 2; done"
07ae4b8674ce935a070d6bf9452ca320737ca898f02641804203dd95fbef7a26

$ docker exec ubu bash -c "echo 나는 exec로 띄운 새 프로세스; ps -ef"
나는 exec로 띄운 새 프로세스
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  9 11:24 ?        00:00:00 bash -c i=0; while true; do echo tick $i; i=$((i+1)); sleep 2; done
root           7       1  0 11:24 ?        00:00:00 sleep 2
root           8       0 75 11:24 ?        00:00:00 ps -ef

$ docker exec ubu bash -c "exit 0"; docker ps --filter name=ubu --format "{{.Names}} {{.Status}}"
ubu Up 1 second

$ timeout 5 docker attach --sig-proxy=true ubu; echo "attach 종료 코드=$?"
tick 1
tick 2
tick 3
attach 종료 코드=124

$ docker ps --filter name=ubu --format "{{.Names}} {{.Status}}"
ubu Up 6 seconds

$ docker logs --tail 3 ubu
tick 1
tick 2
tick 3

$ docker stats --no-stream ubu
CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O         BLOCK I/O   PIDS
07ae4b8674ce   ubu       0.04%     2.164MiB / 15.24GiB   0.01%     1.17kB / 126B   0B / 0B     2

$ docker stop ubu
ubu

$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

$ docker ps -a
CONTAINER ID   IMAGE          COMMAND                   CREATED          STATUS                                PORTS     NAMES
07ae4b8674ce   ubuntu:24.04   "bash -c 'i=0; while…"   13 seconds ago   Exited (137) Less than a second ago             ubu
29b254362ca1   hello-world    "/hello"                  53 seconds ago   Exited (0) 52 seconds ago                       hello

$ docker start ubu && docker ps --format "{{.Names}} {{.Status}}"
ubu
ubu Up Less than a second

$ docker rm -f ubu hello
ubu
hello

```

## ubuntu 컨테이너 내부 진입(대화형 셸): 메인 프로세스인 bash가 exit 하면 컨테이너도 종료

```bash
$ printf "hostname\nls /\necho hi from inside\nexit\n" | docker run -i --name shell ubuntu:24.04 bash
0acf5d448c4d
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
hi from inside

$ docker ps -a --filter name=shell --format "{{.Names}} {{.Status}}"
shell Exited (0) Less than a second ago

$ docker rm shell
shell

```
