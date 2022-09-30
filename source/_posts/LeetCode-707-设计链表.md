---
title: LeetCode-707.设计链表
tags:
  - LeetCode
  - 代码随想录
  - 链表
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: 2ed3
date: 2022-09-30 18:23:55
updated: 2022-09-30 18:23:55
---

## [题目](https://leetcode.cn/problems/design-linked-list/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0707.设计链表.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=685492340&bvid=BV1FU4y1X7WD&cid=758264222&page=1&high_quality=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

1. 先定义节点类`ListNode`，在他基础上实现链表类`MyLinkedList`
2. `MyLinkedList`的构造函数中需要链表的头结点`head`和长度`size`，后续的方法操作会更新相应的值

### 看完[代码随想录](https://programmercarl.com/0707.设计链表.html)之后的想法

- 链表的增删操作都可以直接用*虚拟头节点*

### 实现过程中遇到的困难

边界情况总是忘记处理，出现空指针异常，提交了多次才ac，比如：

- `addAtTail`时如果链表为空，实际就是`addAtHead`
- `addAtIndex``index <= 0`时实际就是`addAtHead`，`index === this.size`时实际就是`addAtTail`
- `deleteAtIndex`可能会删头结点，需要用一个`dummyHead`来处理

### 代码

```ts TypeScript
class LinkNode {
  val: any
  next: LinkNode | null
  constructor(val?: any, next?: LinkNode | null) {
    this.val = val
    this.next = next || null
  }
}

/**
* Your MyLinkedList object will be instantiated and called as such:
* var obj = new MyLinkedList()
* var param_1 = obj.get(index)
* obj.addAtHead(val)
* obj.addAtTail(val)
* obj.addAtIndex(index,val)
* obj.deleteAtIndex(index)
*/
class MyLinkedList {
  size: number
  head: LinkNode | null
  constructor() {
    this.size = 0
    this.head = null
  }

  get(index: number): number {
    let cur = this.head
    while (cur && index--) cur = cur.next
    return cur ? cur.val : -1
  }

  addAtHead(val: number): void {
    this.head = new LinkNode(val, this.head)
    this.size++
  }

  addAtTail(val: number): void {
    if (this.size === 0) {
      this.addAtHead(val)
      return
    }
    let cur = this.head
    while (cur.next) cur = cur.next
    cur.next = new LinkNode(val)
    this.size++
  }

  addAtIndex(index: number, val: number): void {
    if (index > this.size) return
    if (index <= 0) {
      this.addAtHead(val)
      return
    }
    if (index === this.size) {
      this.addAtTail(val)
      return
    }
    let cur = this.head
    while (index-- > 1) cur = cur.next
    cur.next = new LinkNode(val, cur.next)
    this.size++
  }

  deleteAtIndex(index: number): void {
    if (index < 0 || index >= this.size) return
    let dummyHead = new LinkNode()
    dummyHead.next = this.head
    let cur = dummyHead
    while (index--) cur = cur.next
    cur.next = cur.next.next
    this.head = dummyHead.next
    this.size--
  }
}
```

## 收获

- 对[链表](/tags/链表/)操作和手写数据结构有了更多认识
