# 05_build_port.md

[← README로 돌아가기](../README.md)

```bash
$ docker build --progress=plain -t codyssey-web:1.0 . 2>&1 | grep -vE "^#[0-9]+ (sha256|resolve|transferring|extracting)"
#0 building with "desktop-linux" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 DONE 0.1s

#2 [internal] load metadata for docker.io/library/nginx:1.27-alpine
#2 DONE 0.2s

#3 [internal] load .dockerignore
#3 DONE 0.1s

#4 [1/3] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#4 ...

#5 [internal] load build context
#5 DONE 0.2s

#4 [1/3] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#4 DONE 0.6s

#4 [1/3] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#4 DONE 0.9s

#4 [1/3] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#4 DONE 1.3s

#4 [1/3] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#4 DONE 1.4s

#4 [1/3] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#4 DONE 2.1s

#6 [2/3] COPY app/conf/default.conf /etc/nginx/templates/default.conf.template
#6 DONE 0.2s

#7 [3/3] COPY app/site/ /usr/share/nginx/html/
#7 DONE 0.1s

#8 exporting to image
#8 exporting layers
#8 exporting layers 0.4s done
#8 exporting manifest sha256:734d6879622fcaec58566b652b01893eee9213162a5d0cefe1782a5a9c3d9847 0.0s done
#8 exporting config sha256:07507a8e0a2b4e070677813c3c3a74505094fa03d4c8f61fd7b59935e75285a6 0.0s done
#8 exporting attestation manifest sha256:71f21c4983250a17bdb9b7aff98b22d47792fddedf03c09580c1b7225ad791ff
#8 exporting attestation manifest sha256:71f21c4983250a17bdb9b7aff98b22d47792fddedf03c09580c1b7225ad791ff 0.1s done
#8 exporting manifest list sha256:50273fab5627eb4a313fee9c4d942a8f43d61e0d18bbe9456054c057ff066afe 0.0s done
#8 naming to docker.io/library/codyssey-web:1.0
#8 naming to docker.io/library/codyssey-web:1.0 done
#8 unpacking to docker.io/library/codyssey-web:1.0 0.1s done
#8 DONE 0.9s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/qien4h27feiankzwuxnxw24qw

$ docker images codyssey-web
IMAGE              ID             DISK USAGE   CONTENT SIZE   EXTRA
codyssey-web:1.0   50273fab5627       73.6MB           21MB        

$ docker inspect codyssey-web:1.0 --format "Labels={{json .Config.Labels}}\nEnv={{json .Config.Env}}\nExposed={{json .Config.ExposedPorts}}"
Labels={"maintainer":"NGINX Docker Maintainers <docker-maint@nginx.com>","org.opencontainers.image.description":"Codyssey dev workstation custom nginx","org.opencontainers.image.title":"codyssey-web"}\nEnv=["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin","NGINX_VERSION=1.27.5","PKG_RELEASE=1","DYNPKG_RELEASE=1","NJS_VERSION=0.8.10","NJS_RELEASE=1","APP_ENV=dev"]\nExposed={"80/tcp":{}}

$ docker run -d -p 8080:80 --name web-8080 codyssey-web:1.0
d35295a6702584cd8b8bdec50ba40a5b970ff7719b925827508c28a975cf7182

$ docker run -d -p 8081:80 -e APP_ENV=prod --name web-8081 codyssey-web:1.0
df3f21df168f5d61985657da36e1087329295c7575ca45b94f25e55d990130c6

$ docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
NAMES      IMAGE              STATUS                    PORTS
web-8081   codyssey-web:1.0   Up 12 seconds (healthy)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp
web-8080   codyssey-web:1.0   Up 13 seconds (healthy)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp

$ curl -s http://localhost:8080 | head -12
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Codyssey Dev Workstation</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <main>
    <h1>Hello, Codyssey! 🐳</h1>
    <p>Dockerfile(nginx:alpine 기반)로 만든 커스텀 웹 서버입니다.</p>

$ curl -sI http://localhost:8080 | grep -iE "^(HTTP|server|x-app-env)"
HTTP/1.1 200 OK
Server: nginx/1.27.5
X-App-Env: dev

$ curl -sI http://localhost:8081 | grep -iE "^(HTTP|server|x-app-env)"
HTTP/1.1 200 OK
Server: nginx/1.27.5
X-App-Env: prod

$ curl -s http://localhost:8081/health
ok

$ docker logs web-8080 2>&1 | tail -5
2026/11/09 11:24:50 [notice] 1#1: start worker process 46
2026/11/09 11:24:50 [notice] 1#1: start worker process 47
127.0.0.1 - - [09/Nov/2026:11:25:00 +0000] "GET /health HTTP/1.1" 200 3 "-" "Wget" "-"
172.17.0.1 - - [09/Nov/2026:11:25:04 +0000] "GET / HTTP/1.1" 200 425 "-" "curl/8.23.0" "-"
172.17.0.1 - - [09/Nov/2026:11:25:04 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/8.23.0" "-"

$ docker stats --no-stream web-8080 web-8081
CONTAINER ID   NAME       CPU %     MEM USAGE / LIMIT     MEM %     NET I/O           BLOCK I/O     PIDS
d35295a67025   web-8080   0.00%     11.59MiB / 15.24GiB   0.07%     2.41kB / 1.71kB   0B / 16.4kB   13
df3f21df168f   web-8081   0.00%     11.41MiB / 15.24GiB   0.07%     2.01kB / 1.13kB   0B / 12.3kB   13

```
