# 07_compose_bonus.md

[← README로 돌아가기](../README.md)

```bash
$ docker compose config --services
web
checker

$ docker compose up -d 2>&1 | grep -vE "^ *(=>|#)"
 Image alpine:3.20 Pulling 
 25f1d6b1951a Pulling fs layer 0B
 25f1d6b1951a Downloading 2.097MB
 25f1d6b1951a Download complete 0B
 25f1d6b1951a Extracting 1B
 3a030ca3f633 Download complete 0B
 25f1d6b1951a Extracting 1B
 25f1d6b1951a Pull complete 0B
 d4050d56ebf2 Download complete 0B
 Image alpine:3.20 Pulled 
 Network codyssey-workstation_default Creating 
 Volume codyssey-workstation_web-logs Creating 
 Network codyssey-workstation_default Creating 
 Volume codyssey-workstation_web-logs Creating 
 Volume codyssey-workstation_web-logs Created 
 Volume codyssey-workstation_web-logs Created 
 Network codyssey-workstation_default Created 
 Network codyssey-workstation_default Created 
 Container cw-web Creating 
 Container cw-web Created 
 Container cw-checker Creating 
 Container cw-checker Created 
 Container cw-web Starting 
 Container cw-web Started 
 Container cw-checker Starting 
 Container cw-checker Started 

$ docker compose ps
NAME         IMAGE              COMMAND                   SERVICE   CREATED         STATUS                            PORTS
cw-checker   alpine:3.20        "sh -c 'while true; …"   checker   9 seconds ago   Up 8 seconds                      
cw-web       codyssey-web:1.0   "/docker-entrypoint.…"   web       9 seconds ago   Up 9 seconds (health: starting)   0.0.0.0:8090->80/tcp, [::]:8090->80/tcp

$ docker compose logs --tail 3 checker
cw-checker  | [checker] 11:25:55 ok
cw-checker  | [checker] 11:26:00 ok

$ docker compose exec checker wget -qO- http://web/ | grep h1
    <h1>Hello, Codyssey! 🐳</h1>

$ curl -sI http://localhost:8090 | grep -iE "^(HTTP|x-app-env)"
HTTP/1.1 200 OK
X-App-Env: dev

$ docker compose down
 Container cw-checker Stopping 
 Container cw-checker Stopped 
 Container cw-checker Removing 
 Container cw-checker Removed 
 Container cw-web Stopping 
 Container cw-web Stopped 
 Container cw-web Removing 
 Container cw-web Removed 
 Network codyssey-workstation_default Removing 
 Network codyssey-workstation_default Removed 

```

## 환경변수로 포트/모드 변경

```bash
$ WEB_PORT=9090 APP_ENV=staging docker compose up -d web 2>&1 | tail -2
 Container cw-web Starting 
 Container cw-web Started 

$ docker compose ps web
NAME      IMAGE              COMMAND                   SERVICE   CREATED         STATUS                            PORTS
cw-web    codyssey-web:1.0   "/docker-entrypoint.…"   web       4 seconds ago   Up 3 seconds (health: starting)   0.0.0.0:9090->80/tcp, [::]:9090->80/tcp

$ curl -sI http://localhost:9090 | grep -iE "^(HTTP|x-app-env)"
HTTP/1.1 200 OK
X-App-Env: staging

$ docker compose down
 Container cw-web Stopping 
 Container cw-web Stopped 
 Container cw-web Removing 
 Container cw-web Removed 
 Network codyssey-workstation_default Removing 
 Network codyssey-workstation_default Removed 

$ docker compose ps -a
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS

```
