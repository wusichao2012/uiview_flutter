// 移动端侧边栏开关
(function () {
  function ensureEls() {
    var header = document.querySelector('.site-header');
    if (!header) return;
    var toggle = document.querySelector('.menu-toggle');
    var sidebar = document.querySelector('.sidebar');
    if (!toggle || !sidebar) return;
    var scrim = document.querySelector('.scrim');
    if (!scrim) {
      scrim = document.createElement('div');
      scrim.className = 'scrim';
      document.body.appendChild(scrim);
    }
    toggle.onclick = function () {
      sidebar.classList.toggle('open');
      scrim.classList.toggle('show');
    };
    scrim.onclick = function () {
      sidebar.classList.remove('open');
      scrim.classList.remove('show');
    };
    sidebar.addEventListener('click', function (e) {
      if (e.target.tagName === 'A') {
        sidebar.classList.remove('open');
        scrim.classList.remove('show');
      }
    });
  }

  // 滚动高亮当前章节
  function setupScrollSpy() {
    var links = Array.prototype.slice.call(
      document.querySelectorAll('.sidebar li a')
    );
    if (!links.length) return;
    var map = {};
    links.forEach(function (a) {
      var id = a.getAttribute('href').slice(1);
      var el = document.getElementById(id);
      if (el) map[id] = a;
    });
    var ids = Object.keys(map);
    function onScroll() {
      var pos = window.scrollY + 120;
      var current = ids[0];
      ids.forEach(function (id) {
        var el = document.getElementById(id);
        if (el && el.offsetTop <= pos) current = id;
      });
      links.forEach(function (a) { a.classList.remove('active'); });
      if (current && map[current]) map[current].classList.add('active');
    }
    window.addEventListener('scroll', onScroll, { passive: true });
    onScroll();
  }

  // 代码复制
  window.copyCode = function (btn) {
    var pre = btn.parentElement.querySelector('pre');
    if (!pre) return;
    var text = pre.innerText;
    navigator.clipboard.writeText(text).then(function () {
      btn.textContent = '已复制';
      btn.classList.add('done');
      setTimeout(function () {
        btn.textContent = '复制';
        btn.classList.remove('done');
      }, 1500);
    });
  };

  document.addEventListener('DOMContentLoaded', function () {
    ensureEls();
    setupScrollSpy();
  });
})();
