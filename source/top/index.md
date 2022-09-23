---
title: 排行榜
comments: false
date: 2022-09-23 23:36:24
---

<div id="post-rank"></div>

<script src="//cdn.jsdelivr.net/npm/leancloud-storage@3.10.0/dist/av-min.js"></script>
<script>
  var APP_ID = 'ISFsnphMrUOU50gzo495Jasy-9Nh9j0Va'  //输入个人LeanCloud账号AppID
  var APP_KEY = 'kCwxOqT1enDtEnxEk5EqpyVm'  //输入个人LeanCloud账号AppKey
  AV.init({
    appId: APP_ID,
    appKey: APP_KEY
  });

  var query = new AV.Query('Counter');//表名
  query.descending('time'); //结果按阅读次数降序排序
  <!-- query.limit(10);  //最终只返回10条结果 -->
  query.find().then( response => {
    var content = response.reduce( (accum, {attributes}) => {
      accum += `<p><div class="prefix">热度 ${attributes.time} ℃</div><div><a href="${attributes.url}">${attributes.title}</a></div></p>`
      return accum;
    },"")
    document.querySelector("#post-rank").innerHTML = content;
  })
  .catch( error => {
    console.log(error);
  });
</script>

<style type="text/css">
  #post-rank {
    text-align: center;
  }
  #post-rank .prefix {
    color: #ff4d4f;
  }
</style>
