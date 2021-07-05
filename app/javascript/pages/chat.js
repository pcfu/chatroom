function initBar(barName) {
  const bar = $(`.${barName}-bar`);

  $(document).ready(function () {
    bar.removeClass('no-transitions-on-load');
  });

  if (window.innerWidth < 768) {
    bar.addClass('collapsed');
  }

  const toggler = $(`.${barName}-toggler`);
  toggler.click(function () {
    if (bar.hasClass('collapsed')) {
      bar.removeClass('collapsed');
    } else {
      bar.addClass('collapsed');
    }
  });
}

export function chatFns() {
  initBar('channels');
  initBar('members');
}
