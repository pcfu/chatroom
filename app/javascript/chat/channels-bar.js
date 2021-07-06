export function initChannelsBar() {
  const bar = $('.channels-bar');

  if (window.innerWidth < 768) {
      bar.addClass('collapsed');
  }

  let timeout;
  timeout = setTimeout(function () {
    bar.removeClass('no-transitions-on-load');
    clearTimeout(timeout);
  }, 100);
}
