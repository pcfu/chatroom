import { initTopBar } from './topbar';
import { initSideBars } from './sidebars';

$(document).on('turbolinks:load', function () {
  const page = window.location.pathname.replace('/', '');
  if (page === 'chat') {
    initTopBar();
    initSideBars();
  }
});
