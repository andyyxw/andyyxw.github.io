<!-- JS库 clipboard 拷贝内容到粘贴板-->
<script src="https://cdn.bootcss.com/clipboard.js/2.0.1/clipboard.min.js"></script>

<!-- JS库 sweetalert 显示提示信息-->
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>

<ul class="post-copyright">
  <!-- 本文标题 -->
  {% if theme.post_copyright.show_title %}
    <li>
      <strong>{{ __('post.copyright.title') + __('symbol.colon') }} </strong>
      {{ post.title }}
    </li>
  {% endif %}

  <!-- 本文作者 -->
  <li class="post-copyright-author">
    <strong>{{ __('post.copyright.author') + __('symbol.colon') }} </strong>
    {{ post.author | default(author) }}
  </li>

  <!-- 创建时间 -->
  {% if theme.post_copyright.show_date %}
    <li>
      <strong>{{ __('post.created') + __('symbol.colon') }} </strong>
      {{ post.date.format("YYYY年MM月DD日 - HH时MM分") }}
    </li>
  {% endif %}

  <!-- 修改时间 -->
  {% if theme.post_copyright.show_updated %}
    <li>
      <strong>{{ __('post.modified') + __('symbol.colon') }} </strong>
      {{ post.updated.format("YYYY年MM月DD日 - HH时MM分") }}
    </li>
  {% endif %}

  <!-- 引用链接 -->
  <li class="post-copyright-link">
    <strong>{{ __('post.copyright.link') + __('symbol.colon') }}</strong>
    <a href="{{ post.url | default(post.permalink) }}" title="{{ post.title }}"
      >{{ post.url | default(post.permalink) }}</a
    >
    <span class="copy-path" title="点击复制引用链接"
      ><i
        style="cursor: pointer"
        class="fa fa-clipboard"
        data-clipboard-text="[{{ post.author | default(author) }}'s Blog | {{ post.title }}]({{ post.permalink }})"
        aria-label="{{ __('post.copy_success') }}"
      ></i
    ></span>
  </li>

  <!-- 版权声明 -->
  <li class="post-copyright-license">
    <strong
      >{{ __('post.copyright.license_title') + __('symbol.colon') }}
    </strong>
    {{ __('post.copyright.license_content', theme.post_copyright.license) }}
  </li>
</ul>

<script>
  var clipboard = new ClipboardJS(".fa-clipboard");
  clipboard.on("success", function(target) {
    var message = document.createElement("div");
    message.innerHTML =
      '<i class="fa fa-check-circle message-icon"></i><span class="message-content">' +
      target.trigger.getAttribute("aria-label") +
      "</span>";
    swal({
      content: message,
      className: "copy-success-message",
      timer: 1000,
      button: false
    });
  });
</script>
