---
title: JS Iframe与父级页面通信及IE9兼容性
tags:
  - JS
  - Iframe
categories:
  - 前端
  - Iframe
abbrlink: d4bd
date: 2019-09-04 11:04:24
description: JS Iframe与父级页面通信及IE9兼容性
related_posts: true
---


> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 <https://www.cnblogs.com/haosit/p/11301350.html>

**一、 postMessage**

　　window.postMessage() 方法安全地启用 Window 对象之间的跨源通信；例如，在页面和它产生的弹出窗口之间，或者在页面和嵌入其中的 iframe 之间。

**二、语法**

　　otherWindow.postMessage(message, targetOrigin, [transfer]);

　　**otherWindow：**是接收对象的窗体引用，例如：子窗体 (iframe) 对父级窗体的引用 "window.parent" 或者其他 Iframe 的引用 “Window.frames + 索引值(命名或数字)”

**message：**将要发送到其他 window 的数据。在 IE9 以下的浏览器, message 不支持 JSON 对象，必须是字符串类型

　　**targetOrigin：**通过窗口的 origin 属性来指定哪些窗口能接收到消息事件，其值可以是字符串 "*"（表示无限制）或者一个 URI。在发送消息的时候，如果目标窗口的协议、主机地址或端口这三者的任意一项不匹配 targetOrigin 提供的值，那么消息就不会被发送；只有三者完全匹配，消息才会被发送。

　　**transfer：**是一串和 message 同时传递的 `Transferable` 对象. 这些对象的所有权将被转移给消息的接收方，而发送一方将不再保有所有权。

**三、应用子窗体和父窗体之间的通信**

**1. parent.html：**添加有 Iframe(childIframe.html) 页面，并监听 message 事件

```
<html>
<head>
    <meta charset="utf-8" />
    <meta  />
    <title></title>
    <style>
        iframe{
            border:none;
            width:100%;
        }
    </style>
</head>
<body>
    <h1>parent</h1>
    <iframe src="childiframe.html"></iframe>
    <script>
        window.addEventListener("message", function (message) {
            alert(JSON.stringify(message.data));
        });
    </script>
</body>
</html>

```

**2. childIframe.html：**直接向 parent 发送一条消息

```
<html>
<head>
    <meta charset="utf-8" />
    <meta  />
    <title></title>
</head>
<body>
    <h1>childIframe</h1>

    <script>
        window.parent.postMessage({type:"open",url:"iframe.html"},"*");
    </script>
</body>
</html>

```

**3. IE9 - 兼容问题：**

　　IE9 及以下的浏览器, message 不支持 JSON 对象，必须是字符串类型。发送时将 JSON 转换为字符串

```
window.parent.postMessage(JSON.stringify({ type: "open", url: "iframe.html" }), "*");

```

　　IE9 还是 IE8 不兼容 addEventListener 和 "message" 监听方法和事件，兼容办法

```
//IE8,IE9兼容方法
if (window.attachEvent) {
    window.attachEvent('onmessage', function (message) {
        console.log(JSON.parse(message.data));
    });
} else {
    window.addEventListener('message', function (message) {
        console.log(JSON.parse(message.data));
    });
}

```
