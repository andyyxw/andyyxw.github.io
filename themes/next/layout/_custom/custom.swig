{# 页脚站点运行时间统计 #} {% if theme.footer.ages.enable %}
<script src="https://cdn.jsdelivr.net/npm/moment@2.22.2/moment.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/moment-precise-range-plugin@1.3.0/moment-precise-range.min.js"></script>
<script>
  function timer() {
    var ages = moment.preciseDiff(moment(),moment({{ theme.footer.ages.birthday }},"YYYYMMDD"));
    ages = ages.replace(/years?/, "年");
    ages = ages.replace(/months?/, "月");
    ages = ages.replace(/days?/, "天");
    ages = ages.replace(/hours?/, "小时");
    ages = ages.replace(/minutes?/, "分");
    ages = ages.replace(/seconds?/, "秒");
    ages = ages.replace(/\d+/g, '<span style="color:{{ theme.footer.ages.color }}">$&</span>');
    div.innerHTML = `{{ __('footer.age')}} ${ages}`;
  }
  var div = document.createElement("div");
  //插入到copyright之后
  var copyright = document.querySelector(".copyright");
  document.querySelector(".footer-inner").insertBefore(div, copyright.nextSibling);
  timer();
  setInterval("timer()",1000)
</script>
{% endif %}
