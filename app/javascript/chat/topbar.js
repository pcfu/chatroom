export function initTopBar() {
  ['channels', 'members'].forEach(barName => {
    const bar = $(`.${barName}-bar`);
    const toggler = $(`.${barName}-toggler`);

    toggler.click(function () {
      if (bar.hasClass('collapsed')) {
        bar.removeClass('collapsed');
      } else {
        bar.addClass('collapsed');
      }
    });
  });
}
