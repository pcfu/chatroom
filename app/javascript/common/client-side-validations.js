function _interopDefaultLegacy (e) {
  return e && typeof e === 'object' && 'default' in e ? e : { 'default': e };
}

const $__default = /*#__PURE__*/_interopDefaultLegacy($);

const DATE_REGEX = /^\d{4}(-|\/)(0[1-9]|1[0-2])(-|\/)(0[1-9]|[12]\d|3[01])$/;

function initTemp() {
  if (!window.temp) { window.temp = []; }
}

function shouldSetDobChanged() {
  const element = $('#user_dob');
  if (element.data('changed')) {
    return true;
  } else {
    return DATE_REGEX.test(element.val());
  }
}

window.ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
  add: function add(element, settings, message) {
    initTemp();
    let idx = window.temp.length;
    window.temp[idx] = {
      element: element, settings: settings, message: message
    }

    const form = $__default['default'](element[0].form);

    if (element.data('valid') !== false &&
        form.find("label.message[for='" + element.attr('id') + "']")[0] == null) {
      const inputErrorField = $__default['default'](settings.input_tag);
      const labelErrorField = $__default['default'](settings.label_tag);
      const label = form.find("label[for='" + element.attr('id') + "']:not(.message)");

      if (element.attr('autofocus')) {
        element.attr('autofocus', false);
      }

      element.before(inputErrorField);
      inputErrorField.find('span#input_tag').replaceWith(element);

      const msg = inputErrorField.find('label.message')
      msg.appendTo(label).replaceWith($('<span>').attr('class', 'message'));
      labelErrorField.insertAfter(label);
      labelErrorField.find('label#label_tag').replaceWith(label);
    }

    form.find("label[for='" + element.attr('id') + "'] > span.message")
        .text(message.replace(/\(.+\)/, '').trim());
  },
  remove: function remove(element, settings) {
    /* var form = $__default['default'](element[0].form);
     * var inputErrorFieldClass = $__default['default'](settings.input_tag).attr('class');
     * var inputErrorField = element.closest('.' + inputErrorFieldClass.replace(/ /g, '.'));
     * var label = form.find("label[for='" + element.attr('id') + "']:not(.message)");
     * var labelErrorFieldClass = $__default['default'](settings.label_tag).attr('class');
     * var labelErrorField = label.closest('.' + labelErrorFieldClass.replace(/ /g, '.'));

     * if (inputErrorField[0]) {
     *   inputErrorField.find('#' + element.attr('id')).detach();
     *   inputErrorField.replaceWith(element);
     *   label.detach();
     *   labelErrorField.replaceWith(label);
     * } */
  }
}

window.ClientSideValidations.validators.local['date'] = function(element, options) {
  if (!DATE_REGEX.test(element.val()) ||
      options['min'] && element.val() < options['min'] ||
      options['max'] && element.val() > options['max']) {
    return 'is invalid';
  }
}

const originalFn = window.ClientSideValidations.eventsToBind.input;
window.ClientSideValidations.eventsToBind.input = function input(form) {
  const listeners = originalFn(form);

  listeners['change.ClientSideValidations'] = function changeClientSideValidations() {
    const $element = $__default['default'](this);
    if (($element.attr('id') === 'user_dob' && shouldSetDobChanged()) ||
        $element.attr('id') !== 'user_dob') {
      console.log($element.data());
    }
  };

  listeners['focusout.ClientSideValidations'] = function focusoutClientSideValidations() {
    const $element = $__default['default'](this);
    if ($element.data('changed')) {
      $element.isValid(form.ClientSideValidations.settings.validators);
    }
  };

  return listeners;
}
