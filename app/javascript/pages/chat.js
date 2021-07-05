export function chatFns() {
  $('.channels-toggler').click(function () {
    const chBar = $('.channels-bar');
    if (chBar.hasClass('hide')) {
      chBar.removeClass('hide');
    } else {
      chBar.addClass('hide');
    }
  });
}
