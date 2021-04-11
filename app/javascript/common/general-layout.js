$(document).on('turbolinks:load', function () {
  if ($('body > div.container > div.page-center')[0]) {
    $('body > div.container').addClass('align-items-sm-center');
  }
});
