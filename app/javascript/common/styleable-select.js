$(document).ready(() => {
  $('.styleable-select').click(function () {
    $('.styleable-select').not(this).removeClass('show');
    if ($(this).hasClass('show')) {
      $(this).removeClass('show');
    } else {
      $(this).addClass('show');
    }
  });

  $('.styleable-option').click(function () {
    $(this).siblings().removeClass('selected');
    $(this).addClass('selected');

    const element = $(this).parents('.styleable-select')
                           .find('.styleable-select-prompt');
    element.text($(this).attr('data-value'));
    element.removeClass('default');
  });

  $(document).click(function (event) {
    const target = $(event.target);
    $('.styleable-select').each(function () {
      if (!target.closest(this).length) {
        $(this).removeClass('show');
      }
    });
  });
});
