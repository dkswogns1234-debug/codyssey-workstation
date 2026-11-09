# 03_docker_basic.md

[← README로 돌아가기](../README.md)

```bash
$ docker --version
Docker version 29.9.3, build 5457199

$ docker info 2>&1 | grep -E "^ ?(Context|Server Version|Storage Driver|Operating System|OSType|Architecture|CPUs|Total Memory|Kernel Version|Containers|  Running|Images)"
 Context:    desktop-linux
 Containers: 1
  Running: 0
 Images: 3
 Server Version: 29.9.3
 Storage Driver: overlayfs
 Kernel Version: 6.18.54.1-microsoft-standard-WSL2
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 12
 Total Memory: 15.24GiB

$ docker pull hello-world
Using default tag: latest
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:c567b231f65614688711a75f31518a064258a51d442117a3e771a3a8fdba78ef
Status: Downloaded newer image for hello-world:latest
docker.io/library/hello-world:latest

$ docker run --name hello hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/


$ docker pull ubuntu:24.04
24.04: Pulling from library/ubuntu
7a48b8f0e5c7: Pulling fs layer
98144013299c: Download complete
7a48b8f0e5c7: Download complete
7a48b8f0e5c7: Pull complete
Digest: sha256:fe81560990fae86dc4743202b2cb4d3df98d0bcf949173cecef15ce1127ef852
Status: Downloaded newer image for ubuntu:24.04
docker.io/library/ubuntu:24.04

$ docker pull nginx:1.27-alpine
1.27-alpine: Pulling from library/nginx
39c2ddfd6010: Pulling fs layer
f18232174bc9: Pulling fs layer
197eb75867ef: Pulling fs layer
b464cfdf2a63: Pulling fs layer
61ca4f733c80: Pulling fs layer
d7e507024086: Pulling fs layer
81bd8ed7ec67: Pulling fs layer
34a64644b756: Pulling fs layer
34a64644b756: Download complete
d7e507024086: Download complete
b464cfdf2a63: Download complete
197eb75867ef: Download complete
f18232174bc9: Download complete
39c2ddfd6010: Download complete
81bd8ed7ec67: Download complete
61ca4f733c80: Download complete
f18232174bc9: Pull complete
2a84448aca9c: Download complete
b464cfdf2a63: Pull complete
61ca4f733c80: Pull complete
d7e507024086: Pull complete
81bd8ed7ec67: Pull complete
197eb75867ef: Pull complete
9261b9aff737: Download complete
34a64644b756: Pull complete
39c2ddfd6010: Pull complete
Digest: sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
Status: Downloaded newer image for nginx:1.27-alpine
docker.io/library/nginx:1.27-alpine

$ docker images
IMAGE                ID             DISK USAGE   CONTENT SIZE   EXTRA
hello-world:latest   c567b231f656       25.9kB         9.49kB   U    
nginx:1.27-alpine    65645c7bb6a0       74.5MB         21.9MB        
ubuntu:24.04         fe81560990fa        119MB         31.7MB        

$ docker run --rm ubuntu:24.04 bash -c "cat /etc/os-release | head -2; ls /; echo hello from ubuntu container"
PRETTY_NAME="Ubuntu 24.04.5 LTS"
NAME="Ubuntu"
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
hello from ubuntu container

$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED          STATUS                      PORTS     NAMES
29b254362ca1   hello-world   "/hello"   16 seconds ago   Exited (0) 15 seconds ago             hello
```
