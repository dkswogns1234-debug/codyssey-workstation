# 06_bind_volume.md

[← README로 돌아가기](../README.md)

## 1. 바인드 마운트: 호스트 폴더 ↔ 컨테이너 폴더 실시간 반영

```bash
$ cat bind-demo/index.html
<h1>BIND v1 - 호스트에서 작성</h1>

$ docker run -d -p 8082:80 --name web-bind -v "C:/Users/dkswo/Desktop/codyssey-workstation/bind-demo:/usr/share/nginx/html:ro" nginx:1.27-alpine
d88711147a1ffec2f119dbe076efc3fdfe340148b97a89429eb3f1eb68e339ed

$ curl -s http://localhost:8082
<h1>BIND v1 - 호스트에서 작성</h1>

$ echo "<h1>BIND v2 - 호스트에서 수정함 (재빌드/재시작 없음)</h1>" > bind-demo/index.html

$ curl -s http://localhost:8082
<h1>BIND v2 - 호스트에서 수정함 (재빌드/재시작 없음)</h1>

$ docker inspect web-bind --format "{{range .Mounts}}{{.Type}}: {{.Source}} -> {{.Destination}} (RW={{.RW}}){{end}}"
bind: C:/Users/dkswo/Desktop/codyssey-workstation/bind-demo -> /usr/share/nginx/html (RW=false)

$ docker rm -f web-bind
web-bind

```

## 2. Docker 볼륨: 컨테이너 삭제 후에도 데이터 유지

```bash
$ docker volume create codyssey-data
codyssey-data

$ docker volume ls
DRIVER    VOLUME NAME
local     codyssey-data

$ docker volume inspect codyssey-data
[
    {
        "CreatedAt": "2026-11-09T11:25:27Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/codyssey-data/_data",
        "Name": "codyssey-data",
        "Options": null,
        "Scope": "local"
    }
]

$ docker run -d --name vol-test -v codyssey-data:/data ubuntu:24.04 sleep infinity
7c8b34c9470e67a3f533c7081fa5cf5cf6b94f0b468b717532b9992e96a7aaab

$ docker exec vol-test bash -c "echo \"persist me - \$(date -u +%FT%TZ)\" > /data/hello.txt && cat /data/hello.txt"
persist me - 2026-11-09T11:25:29Z

$ docker rm -f vol-test
vol-test

$ docker ps -a --filter name=vol-test
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

$ docker run -d --name vol-test2 -v codyssey-data:/data ubuntu:24.04 sleep infinity
9cb37b288b4035a7efd0ab907d3145894b1554c9690c61f1384c57327f856fae

$ docker exec vol-test2 bash -c "ls -l /data && cat /data/hello.txt"
total 4
-rw-r--r-- 1 root root 34 Nov  9 11:25 hello.txt
persist me - 2026-11-09T11:25:29Z

$ docker rm -f vol-test2
vol-test2

```

## 대조군: 볼륨 없이 컨테이너 내부에만 쓴 데이터는 삭제와 함께 사라짐

```bash
$ docker run -d --name novol ubuntu:24.04 sleep infinity && docker exec novol bash -c "echo temp > /tmp/x.txt && cat /tmp/x.txt" && docker rm -f novol
6067f82da239c263745995d426bfdc5a5277c7bdbfdf194175a1d22ca51d2c4f
temp
novol

$ docker run --rm ubuntu:24.04 bash -c "cat /tmp/x.txt || echo 파일 없음"
cat: /tmp/x.txt: No such file or directory
파일 없음

```
