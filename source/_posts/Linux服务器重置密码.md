---
title: 服务器重置密码
abbrlink: fe92
date: 2018-10-15 17:33:12
tags: 
    - 服务器
    - Linux
    - 重置密码
categories: 
    - 服务器
description: Linux服务器重置密码
related_posts: true
---
有时候会忘记服务器密码，但是可以通过官网面板等方式连上时，可使用下面的命令修改root密码：
整段赋值下面的命令（"新密码"处 替换为要修改的密码）：

```
echo root:新密码 |sudo chpasswd root
sudo sed -i 's/^.*PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config;
sudo sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
sudo reboot
```

重启后用root账户登录即可。
