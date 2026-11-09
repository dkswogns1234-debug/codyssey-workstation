# 01_terminal.md

[← README로 돌아가기](../README.md)

```bash
$ pwd
/home/dkswo

$ rm -rf ~/codyssey && mkdir -p ~/codyssey/practice

$ cd ~/codyssey/practice && pwd
/home/dkswo/codyssey/practice

$ ls -la
total 8
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 .
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 ..

$ touch empty.txt

$ echo "hello codyssey" > memo.txt

$ mkdir docs

$ ls -la
total 16
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 .
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 ..
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 docs
-rw-r--r-- 1 dkswo dkswo    0 Nov  9 20:22 empty.txt
-rw-r--r-- 1 dkswo dkswo   15 Nov  9 20:22 memo.txt

$ cat memo.txt
hello codyssey

$ wc -c empty.txt
0 empty.txt

$ cp memo.txt docs/memo_copy.txt

$ mv empty.txt renamed.txt

$ mv renamed.txt docs/

$ ls -la . docs
.:
total 16
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 .
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 ..
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 docs
-rw-r--r-- 1 dkswo dkswo   15 Nov  9 20:22 memo.txt

docs:
total 12
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 .
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 ..
-rw-r--r-- 1 dkswo dkswo   15 Nov  9 20:22 memo_copy.txt
-rw-r--r-- 1 dkswo dkswo    0 Nov  9 20:22 renamed.txt

$ cd docs && pwd && cd ..
/home/dkswo/codyssey/practice/docs

$ cd ../practice/docs && pwd && cd ~/codyssey/practice
/home/dkswo/codyssey/practice/docs

$ rm docs/renamed.txt

$ ls -la docs
total 12
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 .
drwxr-xr-x 3 dkswo dkswo 4096 Nov  9 20:22 ..
-rw-r--r-- 1 dkswo dkswo   15 Nov  9 20:22 memo_copy.txt

$ echo ".hidden 파일" > .secret && ls && echo "--- ls -a ---" && ls -a
docs
memo.txt
--- ls -a ---
.
..
.secret
docs
memo.txt

```
