$(document).on('turbolinks:load', function () {
  if ($('#navbar-collapsible')[0]) {
    $('.navbar-user-panel').on('click', function () {
      const userLinks = $('.navbar-user-links');
      const visibility = userLinks.css('visibility') === 'hidden' ? 'visible' : 'hidden';
      userLinks.css('visibility', visibility);
    });
  }
});
