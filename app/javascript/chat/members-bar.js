export function initMembersBar() {
  const bar = $('.members-bar');

  if (window.innerWidth < 768) {
      bar.addClass('collapsed');
  }

  let timeout;
  timeout = setTimeout(function () {
    bar.removeClass('no-transitions-on-load');
    clearTimeout(timeout);
  }, 100);

  bar.find('.bar-toggler').click(function () {
    if (bar.hasClass('collapsed')) {
      bar.removeClass('collapsed');
    } else {
      bar.addClass('collapsed');
    }
  });
}
