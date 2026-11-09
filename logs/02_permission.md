# 02_permission.md

[← README로 돌아가기](../README.md)

```bash
$ mkdir -p perm_dir && touch perm_dir/a.txt && echo "data" > perm_file.txt

```

## 파일 권한: 644 → 755 → 600

```bash
$ ls -l perm_file.txt
-rw-r--r-- 1 dkswo dkswo 5 Nov  9 20:22 perm_file.txt

$ stat -c "%A %a %n" perm_file.txt
-rw-r--r-- 644 perm_file.txt

$ chmod 755 perm_file.txt && ls -l perm_file.txt
-rwxr-xr-x 1 dkswo dkswo 5 Nov  9 20:22 perm_file.txt

$ chmod 600 perm_file.txt && ls -l perm_file.txt
-rw------- 1 dkswo dkswo 5 Nov  9 20:22 perm_file.txt

$ chmod u=rw,g=r,o=r perm_file.txt && stat -c "%A %a %n" perm_file.txt
-rw-r--r-- 644 perm_file.txt

```

## 디렉토리 권한: 755 → 700 → 644(x 제거 시 진입 불가)

```bash
$ ls -ld perm_dir
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 perm_dir

$ chmod 700 perm_dir && ls -ld perm_dir
drwx------ 2 dkswo dkswo 4096 Nov  9 20:22 perm_dir

$ chmod 644 perm_dir && ls -ld perm_dir
drw-r--r-- 2 dkswo dkswo 4096 Nov  9 20:22 perm_dir

$ cd perm_dir; echo "exit=$?"
/mnt/c/Users/dkswo/Desktop/codyssey-workstation/scripts/rec.sh: line 3: cd: perm_dir: Permission denied
exit=1

$ ls -l perm_dir
total 0
-????????? ? ? ? ?            ? a.txt

$ chmod 755 perm_dir && ls -ld perm_dir && cd perm_dir && pwd && cd ..
drwxr-xr-x 2 dkswo dkswo 4096 Nov  9 20:22 perm_dir
/home/dkswo/codyssey/practice/perm_dir

```
