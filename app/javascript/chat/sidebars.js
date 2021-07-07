import { noTransitionsOnLoad } from '../common/no-transitions-on-load';

export function initSideBars() {
  ['channels', 'members'].forEach(function (barName) {
    const bar = $(`.${barName}-bar`);
    noTransitionsOnLoad(bar);

    if (window.innerWidth < 768) {
      bar.addClass('collapsed');
    }

    bar.find('.bar-toggler').click(function () {
      if (bar.hasClass('collapsed')) {
        bar.removeClass('collapsed');
      } else {
        bar.addClass('collapsed');
      }
    });
 });
}
