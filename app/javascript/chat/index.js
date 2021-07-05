import { initTopBar } from './topbar';
import { initChannelsBar } from './channels-bar';
import { initMembersBar } from './members-bar';

$(document).on('turbolinks:load', function () {
  const page = window.location.pathname.replace('/', '');
  if (page === 'chat') {
    initTopBar();
    initChannelsBar();
    initMembersBar();
  }
});
