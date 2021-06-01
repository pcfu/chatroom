const MONTHS = [];
const DATE_REGEX = /^\d{4}(-|\/)(0[1-9]|1[0-2])(-|\/)(0[1-9]|[12]\d|3[01])$/;

function loadMonths() {
  Object.entries($('#user_dob_month .styleable-option'))
        .forEach(([k, v]) => {
          if (!isNaN(k)) {
            MONTHS.push(v.getAttribute('data-value').toLowerCase())
          }
        });
}

function getDay() {
  return parseInt($('#user_dob_day .styleable-select-prompt').text());
}

function getMonth() {
  return $('#user_dob_month .styleable-select-prompt').text().toLowerCase();
}

function getYear () {
  return parseInt($('#user_dob_year .styleable-select-prompt').text());
}

function getMonthNumber(month) {
  return MONTHS.indexOf(month) + 1;
}

function getMonthAndYear(changedField, val) {
  return changedField === 'month' ?
         [ val.toLowerCase(), getYear() ] :
         [ getMonth(), parseInt(val) ];
}

function isLeapYear(year) {
  if (isNaN(year)) return false;
  if (year % 400 === 0) return true;
  if (year % 100 === 0) return false;
  return year % 4 === 0;
}

function getMaxDate(month, year) {
  switch (month) {
  case 'february':
    return isLeapYear(year) ? 29 : 28;
  case 'april': case 'june': case 'september': case 'november':
    return 30;
  default:
    return 31;
  }
}

function preSelectDob() {
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

function setDobValue() {
  const month = `${getMonthNumber(getMonth())}`.padStart(2, '0');
  const day = `${getDay()}`.padStart(2, '0');
  $('#user_dob').val(`${getYear()}-${month}-${day}`);
}

function updateDayOptions(maxDate) {
  $('#user_dob_day .styleable-option').each((idx, element) => {
    if (maxDate >= idx + 1) {
      $(element).show();
    } else {
      $(element).hide();
    }
  });
}

function adjustSelectedDay(maxDate) {
  const date = getDay();
  if (!isNaN(date) && date > maxDate) {
    $(`.styleable-option[data-value=${date}]`).removeClass('selected');
    $(`.styleable-option[data-value=${maxDate}]`).addClass('selected');
    $('#user_dob_day .styleable-select-prompt').text(maxDate);
    $('#user_dob_day .styleable-select-prompt').fadeOut(0).fadeIn(400);
  }
}

function shouldSetDobChanged() {
  const element = $('#user_dob');
  if (element.data('changed')) {
    return true;
  } else {
    return DATE_REGEX.test(element.val());
  }
}


export function registerFns() {
  loadMonths();

  // Set dob values for select options
  preSelectDob();

  // Update user dob field when a date option is clicked
  $('.styleable-option').click(function () {
    setDobValue();
    $('#user_dob').trigger('change');
    $('#user_dob').trigger('focusout');
  });

  // Add listener to fix invalid dates when month or year changes
  ['year', 'month'].forEach(field => {
    const selector = `#user_dob_${field} .styleable-option`;

    $(selector).click(function () {
      const [month, year] = getMonthAndYear(field, $(this).data('value'));
      if (month !== 'month') {
        const maxDate = getMaxDate(month, year);
        updateDayOptions(maxDate);
        adjustSelectedDay(maxDate);
        setDobValue();
      }
    });
  });

  // Enable validation for user d.o.b
  const inputEventBindings = window.ClientSideValidations.eventsToBind.input;

  ClientSideValidations.eventsToBind.input = function input(form) {
    const listeners = inputEventBindings(form);

    listeners['change.ClientSideValidations'] = function changeClientSideValidations() {
      const $element = $(this);
      if (($element.attr('id') === 'user_dob' && shouldSetDobChanged()) ||
          $element.attr('id') !== 'user_dob') {
        $element.data('changed', true);
      }
    };

    listeners['focusout.ClientSideValidations'] = function focusoutClientSideValidations() {
      const $element = $(this);
      if ($element.data('changed')) {
        $element.isValid(form.ClientSideValidations.settings.validators);
      }
    };

    return listeners;
  }

  // Set error message for invalid user d.o.b
  ClientSideValidations.validators.local['date'] = function(element, options) {
    if (!DATE_REGEX.test(element.val()) ||
        options['min'] && element.val() < options['min'] ||
        options['max'] && element.val() > options['max']) {
      return 'is invalid';
    }
  }
}
