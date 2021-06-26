function getLabel(field) {
  return $(`label[for="session_${field}"]`);
}

function getInput(field) {
  return $(`#session_${field}`);
}

function addError(field, msg) {
  const error_tag = '<div class=field_with_errors><span id="element_tag"></span></div>';
  const label = getLabel(field);
  const input = getInput(field);

  label.before($(error_tag));
  label.prev().find('span#element_tag').replaceWith(label);
  label.append($(`<span class="message">${msg}</span>`));

  input.before($(error_tag));
  input.prev().find('span#element_tag').replaceWith(input);
}

function removeError(field) {
  const label = getLabel(field);
  const input = getInput(field);

  label.find('span.message').remove();
  label.parent('.field_with_errors').replaceWith(label);
  input.parent('.field_with_errors').replaceWith(input);
  input.focus();
}

function hasError(field) {
  return getLabel(field).parent('.field_with_errors')[0];
}

export function loginFns() {
  $('form').on('ajax:before', event => {
    ['username', 'password'].forEach(field => {
      if (hasError(field)) {
        removeError(field);
      }

      if ($(`#session_${field}`).val().trim().length === 0) {
        event.preventDefault();
        addError(field, `please enter ${field}`);
      }
    });
  });

  $('form').on('ajax:stopped', event => {
    const timeout = setTimeout(() => {
      $('input[value="login"]').removeAttr('disabled');
      clearTimeout(timeout);
    }, 100);
  });

  $('form').on('ajax:error', event => {
    const [data, status, xhr] = event.detail;
    if (data.field === 'username' || data.field === 'password') {
      addError(data.field, data.msg);
    }
  });

  $('form').on('ajax:success', event => {
    window.location.replace('/chat');
  })

  $('input.form-control').on('keyup', function () {
    const field = $(this).attr('id').replace('session_', '');
    if (hasError(field)) {
      removeError(field);
    }
  });
}
