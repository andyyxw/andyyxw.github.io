# Blog Backup

踩坑记录：

- [hexo-git-backup](https://github.com/coneycode/hexo-git-backup) 插件有bug：
  1. 安装依赖后还需要`remote`一下对应的`repo`，比如需要备份到`github`就执行：`git remote add github git@github.com:andyyxw/andyyxw.github.io.git`，其他`repo`同理
  2. 源码中`git.js`第134行一处bug：
      > ~~commands.push(['push', '-u', t, 'master:' + repo[t].branch, '--force']);~~
      > >
      > commands.push(['push', '-u', t, repo[t].branch, '--force']);
- [hexo-leancloud-counter-security](https://github.com/theme-next/hexo-leancloud-counter-security) 插件y有bug，参看[commit](https://github.com/theme-next/hexo-leancloud-counter-security/pull/28/commits/492b946d6ea8a1b5313796767b5bfa778420cd4f)
  1. 第43行新增：`let { log } = this;`
  2. 第73行修改：`this.log.info` 为 `log.info`
