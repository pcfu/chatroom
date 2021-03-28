$(document).ready(function () {
  function getDay() {
    return parseInt($('#user_dob_day .styleable-select-prompt').text());
  }

  function getMonth() {
    return $('#user_dob_month .styleable-select-prompt').text().toLowerCase();
  }

  function getYear() {
    return parseInt($('#user_dob_year .styleable-select-prompt').text());
  }

  function getMonthNames() {
    const names = [];
    Object.entries($('#user_dob_month .styleable-option'))
          .forEach(([k, v]) => {
            if (!isNaN(k)) {
              names.push(v.getAttribute('data-value').toLowerCase())
            }
          });
    return names;
  }

  function getMonthNumber(month) {
    return MONTHS.indexOf(month) + 1;
  }

  function getMonthAndYear(changedField, val) {
    return changedField === 'month' ?
           [val.toLowerCase(), getYear()] :
           [getMonth(), parseInt(val)];
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

  function setDobValue() {
    const month = `${getMonthNumber(getMonth())}`.padStart(2, '0');
    const day = `${getDay()}`.padStart(2, '0');
    $('#user_dob').val(`${getYear()}-${month}-${day}`);
  }


  const MONTHS = getMonthNames();

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

  // Update user dob field when a date option is clicked
  $('.styleable-option').click(setDobValue);
});
