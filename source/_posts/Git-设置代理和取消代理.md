---
title: Git 设置代理和取消代理
description: 提高 git clone 速度
abbrlink: a16d
date: 2019-09-23 17:22:30
tags:
categories:
---


如果代理类型是 socks5 进行如下设置即可：
```
git config --global http.proxy socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080
```

如果是普通的 http/https 进行如下设置即可：
```
git config --global https.proxy http://127.0.0.1:1080
git config --global https.proxy https://127.0.0.1:1080
```

取消代理设置：
```
git config --global --unset http.proxy
git config --global --unset https.proxy
```
