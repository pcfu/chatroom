function hideElement(elem) {
  elem.removeClass('show');
  elem.addClass('hide');
}

function showElement(elem) {
  elem.removeClass('hide');
  elem.addClass('show');
}

$(document).on('turbolinks:load', function () {
  if ($('#navbar-collapsible')[0]) {
    $('.navbar-user-panel').on('click', function () {
      const userLinks = $('.navbar-user-links.logged-in');
      if (userLinks.hasClass('show')) {
        hideElement(userLinks);
      } else {
        showElement(userLinks);
      }
    });

    $(document).click(function (event) {
      const target = $(event.target);
      $('.navbar-user-links.logged-in.show').each(function () {
        const targetInUserPanel = target.closest($('.navbar-user-panel')).length > 0;
        const targetInUserLinks = target.closest(this).length > 0;

        if (!targetInUserPanel && !targetInUserLinks) {
          hideElement($(this));
        }
      });
    });
  }
});
