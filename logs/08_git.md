# 08_git.md

[← README로 돌아가기](../README.md)

```bash
$ git --version
git version 2.56.0.windows.4

$ git config --global init.defaultBranch
main

$ git config --list --show-origin | grep -vE "credential|token" | sed -E "s/(user\.email=)[^@]+/\1****/"
file:C:/Program Files/Git/etc/gitconfig	diff.astextplain.textconv=astextplain
file:C:/Program Files/Git/etc/gitconfig	filter.lfs.clean=git-lfs clean -- %f
file:C:/Program Files/Git/etc/gitconfig	filter.lfs.smudge=git-lfs smudge -- %f
file:C:/Program Files/Git/etc/gitconfig	filter.lfs.process=git-lfs filter-process
file:C:/Program Files/Git/etc/gitconfig	filter.lfs.required=true
file:C:/Program Files/Git/etc/gitconfig	http.sslbackend=schannel
file:C:/Program Files/Git/etc/gitconfig	core.autocrlf=true
file:C:/Program Files/Git/etc/gitconfig	core.fscache=true
file:C:/Program Files/Git/etc/gitconfig	core.symlinks=false
file:C:/Program Files/Git/etc/gitconfig	pull.rebase=false
file:C:/Program Files/Git/etc/gitconfig	init.defaultbranch=master
file:C:/Users/dkswo/.gitconfig	user.name=dkswogns1234-debug
file:C:/Users/dkswo/.gitconfig	user.email=****@gmail.com
file:C:/Users/dkswo/.gitconfig	init.defaultbranch=main
file:C:/Users/dkswo/.gitconfig	core.autocrlf=input

$ git init
Initialized empty Git repository in C:/Users/dkswo/Desktop/codyssey-workstation/.git/

$ git branch --show-current || git symbolic-ref --short HEAD
main

```

## GitHub 원격 저장소 연동 (VSCode Publish Branch → 공개 전환)

```bash
$ git remote -v
origin	https://github.com/dkswogns1234-debug/codyssey-workstation.git (fetch)
origin	https://github.com/dkswogns1234-debug/codyssey-workstation.git (push)

$ git status -sb | head -1
## main...origin/main

$ git ls-remote origin
d96dc63b7f54eff6868d5a0203664b73e87cca14	HEAD
d96dc63b7f54eff6868d5a0203664b73e87cca14	refs/heads/main

$ curl -s -o /dev/null -w "%{http_code}\n" https://github.com/dkswogns1234-debug/codyssey-workstation
200

```
