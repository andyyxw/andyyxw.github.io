---
title: LeetCode-19.删除链表的倒数第 N 个结点
tags:
  - LeetCode
  - 代码随想录
  - 链表
  - 双指针
  - 快慢指针
categories:
  - 算法
description: ' '
related_posts: true
copyright: true
abbrlink: f12f
date: 2022-10-03 10:20:58
updated: 2022-10-03 10:20:58
---

## [题目](https://leetcode.cn/problems/remove-nth-node-from-end-of-list/)详解

### 相关链接

- [代码随想录](https://programmercarl.com/0019.删除链表的倒数第N个节点.html)

<iframe class="iframe_video" src="//player.bilibili.com/player.html?aid=940659258&bvid=BV1vW4y1U7Gf&cid=767366533&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>

### 思路

- 本题关键是找到倒数第n个节点：
  1. 快慢指针
  2. 快指针先跑n步
  3. 然后两个指针同步跑，最后快指针到达末尾时停止
  4. 慢指针则刚好到达倒数第n个节点
- 需要用虚拟头节点，因为可能删除的是头结点

### 看完[代码随想录](https://programmercarl.com/0019.删除链表的倒数第N个节点.html)之后的想法

- 快慢指针迭代法与我的思路一致，学会了递归倒退n法

### 实现过程中遇到的困难

- 慢指针要停在删除节点的前一个节点

### 代码

- 快慢指针
  ```ts TypeScript
  /**
   * Definition for singly-linked list.
   * class ListNode {
   *     val: number
   *     next: ListNode | null
   *     constructor(val?: number, next?: ListNode | null) {
   *         this.val = (val===undefined ? 0 : val)
   *         this.next = (next===undefined ? null : next)
   *     }
   * }
   */

  function removeNthFromEnd(head: ListNode | null, n: number): ListNode | null {
    let dummyHead = new ListNode()
    dummyHead.next = head
    let slow = dummyHead,
      fast = dummyHead
    while (n--) fast = fast.next
    while (fast.next) {
      slow = slow.next
      fast = fast.next
    }
    slow.next = slow.next.next
    return dummyHead.next
  }
  ```
- 递归
  ```ts TypeScript
  /**
  * Definition for singly-linked list.
  * class ListNode {
  *     val: number
  *     next: ListNode | null
  *     constructor(val?: number, next?: ListNode | null) {
  *         this.val = (val===undefined ? 0 : val)
  *         this.next = (next===undefined ? null : next)
  *     }
  * }
  */

  function removeNthFromEnd(head: ListNode | null, n: number): ListNode | null {
    let dummyHead = new ListNode()
    dummyHead.next = head
    let count = 0
    function recursion(node : ListNode | null) {
      if (!node) return
      recursion(node.next)
      count++
      if (count === n + 1) node.next = node.next.next
    }
    recursion(dummyHead)
    return dummyHead.next
  }
  ```

时间复杂度：O(n)
空间复杂度：O(1)

## 收获
