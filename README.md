# Blog Backup

踩坑记录：

- [hexo-git-backup](https://github.com/coneycode/hexo-git-backup)
  - 插件有bug，修复步骤：
    1. 安装依赖后还需要`remote`一下对应的`repo`，比如需要备份到`github`就执行：`git remote add github git@github.com:andyyxw/andyyxw.github.io.git`，其他`repo`同理
    2. 源码中`git.js`第134行一处bug：
        > ~~commands.push(['push', '-u', t, 'master:' + repo[t].branch, '--force']);~~
        >
        > commands.push(['push', '-u', t, repo[t].branch, '--force']);
