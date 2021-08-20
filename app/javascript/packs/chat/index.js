import { initTopBar } from './topbar';
import { initSideBars } from './sidebars';

$(document).on('turbolinks:load', function () {
  initTopBar();
  initSideBars();
});
