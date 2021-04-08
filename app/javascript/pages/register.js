function getSupportingFunctions() {
  const MONTHS = [];
  Object.entries($('#user_dob_month .styleable-option'))
        .forEach(([k, v]) => {
          if (!isNaN(k)) {
            MONTHS.push(v.getAttribute('data-value').toLowerCase())
          }
        });

  return {
    getDay: function () {
      return parseInt($('#user_dob_day .styleable-select-prompt').text());
    },
    getMonth: function () {
      return $('#user_dob_month .styleable-select-prompt').text().toLowerCase();
    },
    getYear: function () {
      return parseInt($('#user_dob_year .styleable-select-prompt').text());
    },
    getMonthNumber: function (month) {
      return MONTHS.indexOf(month) + 1;
    },
    getMonthAndYear: function (changedField, val) {
      return changedField === 'month' ?
             [ val.toLowerCase(), this.getYear() ] :
             [ this.getMonth(), parseInt(val) ];
    },
    isLeapYear: function (year) {
      if (isNaN(year)) return false;
      if (year % 400 === 0) return true;
      if (year % 100 === 0) return false;
      return year % 4 === 0;
    },
    getMaxDate: function (month, year) {
      switch (month) {
      case 'february':
        return this.isLeapYear(year) ? 29 : 28;
      case 'april': case 'june': case 'september': case 'november':
        return 30;
      default:
        return 31;
      }
    },
    updateDayOptions: function (maxDate) {
      $('#user_dob_day .styleable-option').each((idx, element) => {
        if (maxDate >= idx + 1) {
          $(element).show();
        } else {
          $(element).hide();
        }
      });
    },
    adjustSelectedDay: function (maxDate) {
      const date = this.getDay();
      if (!isNaN(date) && date > maxDate) {
        $(`.styleable-option[data-value=${date}]`).removeClass('selected');
        $(`.styleable-option[data-value=${maxDate}]`).addClass('selected');
        $('#user_dob_day .styleable-select-prompt').text(maxDate);
        $('#user_dob_day .styleable-select-prompt').fadeOut(0).fadeIn(400);
      }
    },
    setDobValue: function () {
      const month = `${this.getMonthNumber(this.getMonth())}`.padStart(2, '0');
      const day = `${this.getDay()}`.padStart(2, '0');
      $('#user_dob').val(`${this.getYear()}-${month}-${day}`);
    },
    preSelectDob: function () {
      const [year, month, day] = $('#user_dob').val().split('-');
      if (!isNaN(year) && !isNaN(month) && !isNaN(day)) {
        $(`.styleable-option[data-value=${year}]`).addClass('selected');
        $('#user_dob_year .styleable-select-prompt').text(year).removeClass('default');

        $(`.styleable-option[data-value=${+day}]`).addClass('selected');
        $('#user_dob_day .styleable-select-prompt').text(+day).removeClass('default');

        const mthOption = $(`#user_dob_month .styleable-option:nth-child(${+month})`);
        $(`.styleable-option[data-value=${mthOption.attr('data-value')}]`).addClass('selected');
        $('#user_dob_month .styleable-select-prompt').text(mthOption.attr('data-value')).removeClass('default');
      }
    }
  };
}

$(document).on('turbolinks:load', function () {
  if (window.location.pathname === '/register') {
    const funcs = getSupportingFunctions();

    // Select dob values for select options
    funcs.preSelectDob();

    // Update user dob field when a date option is clicked
    $('.styleable-option').click(function () {
      funcs.setDobValue();
      $('#user_dob').trigger('change');
      $('#user_dob').trigger('focusout');
    });

    // Add listener to fix invalid dates when month or year changes
    ['year', 'month'].forEach(field => {
      const selector = `#user_dob_${field} .styleable-option`;

      $(selector).click(function () {
        const [month, year] = funcs.getMonthAndYear(field, $(this).data('value'));
        if (month !== 'month') {
          const maxDate = funcs.getMaxDate(month, year);
          funcs.updateDayOptions(maxDate);
          funcs.adjustSelectedDay(maxDate);
          funcs.setDobValue();
        }
      });
    });
  }
});
