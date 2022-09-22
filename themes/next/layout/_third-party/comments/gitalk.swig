{% if page.comments && theme.gitalk.enable %}
  <!-- <link rel="stylesheet" href="https://unpkg.com/gitalk/dist/gitalk.css"> -->
  <link href="https://cdn.jsdelivr.net/npm/gitalk@1.7.2/dist/gitalk.css" rel="stylesheet">
  <!-- <script src="https://unpkg.com/gitalk/dist/gitalk.min.js"></script> -->
  <script src="https://cdn.jsdelivr.net/npm/gitalk@1.7.2/dist/gitalk.min.js"></script>
  <script src="https://cdn.bootcss.com/blueimp-md5/2.12.0/js/md5.min.js"></script>
  <script type="text/javascript">
    /*
      双层括号 返回的就是_config.yml配置文件中的内容，如果没有这一项就就返回空内容。

      clientID：GitHub Application Client ID.
      clientSecret：GitHub Application Client Secret.
      repo：GitHub repository.
      owner： GitHub repository 所有者，可以是个人或者组织。
      admin： GitHub repository 的所有者和合作者 (对这个 repository 有写权限的用户)。指定可初始化评论的账户（初始评论时即 生成了一个issue）。
      id：页面的唯一标识。长度必须小于50。
        id会被保存为 issue 的一个 label，用来关联文章和 issue。（github限制label长度不超过50）
        所以用md5处理一下避免长度超限，不然会报错"Error: Validation Failed"。参看 https://github.com/gitalk/gitalk/issues/102
      distractionFreeMode：Facebook-like distraction free mode.专注模式(评论时的全屏遮罩)。
      createIssueManually：如果当前页面没有相应的 isssue 且登录的用户属于 admin，则会自动创建 issue。如果设置为 true，则显示一个初始化页面，创建 issue 需要点击 init 按钮。
    */
    var gitalk = new Gitalk({
      clientID: '{{ theme.gitalk.ClientID }}',
      clientSecret: '{{ theme.gitalk.ClientSecret }}',
      repo: '{{ theme.gitalk.repo }}',
      owner: '{{ theme.gitalk.githubID }}',
      admin: ['{{ theme.gitalk.githubID }}'],
      id: md5(location.pathname),
      distractionFreeMode: true,
      createIssueManually: true,
    })
    gitalk.render('gitalk-container')
  </script>
{% endif %}
