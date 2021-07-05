export function initMembersBar() {
  const bar = $('.members-bar');

  $(document).ready(function () {
    bar.removeClass('no-transitions-on-load');

    if (window.innerWidth < 768) {
      bar.addClass('collapsed');
    }
  });
}
