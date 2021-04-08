function _interopDefaultLegacy (e) {
  return e && typeof e === 'object' && 'default' in e ? e : { 'default': e };
}

const $__default = /*#__PURE__*/_interopDefaultLegacy($);


/******************************************************
 * Callbacks to run for Password/Password Confirmaton *
 ******************************************************/

// Force validation of password confirmation on submitting form
ClientSideValidations.callbacks.form.before = function(form, eventData) {
  const element = $('#user_password')
  element.data({'changed': true, 'validateConfirmation': true});
  element.trigger('focusout');
  element.removeData('validateConfirmation');
}

ClientSideValidations.callbacks.element.fail = function(element, message, callback, eventData) {
  if (message.includes("doesn't match")) {
    // remove errors from main field as those have all passed
    const settings = element[0].form.ClientSideValidations.settings.html_settings;
    ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'].remove(element, settings);

    // add errors to confirmation field
    const confInput = $(`#${element.attr('id')}_confirmation`);
    if (element.data('validateConfirmation') || confInput.data('interacted')) {
      ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'].add(confInput, settings, message);
      confInput.focus();
    }

  } else {
    callback();
  }
}

ClientSideValidations.callbacks.element.pass = function(element, callback, eventData) {
  const id = element.attr('id');
  const conf = $(`#${id}_confirmation`);
  if (conf.length > 0) {
    const settings = element[0].form.ClientSideValidations.settings.html_settings;
    ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'].remove(conf, settings);
  }
  callback();
}


/******************************************
 * Change position of error message label *
 ******************************************/

ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
  add: function add(element, settings, message) {
    const form = $__default['default'](element[0].form);

    // Only wrap with error tags if error message not already present
    if (form.find("label[for='" + element.attr('id') + "'] > span.message")[0] == null) {
      if (element.attr('autofocus')) {
        element.attr('autofocus', false);
      }

      const inputErrorField = $__default['default'](settings.input_tag);
      element.before(inputErrorField);
      inputErrorField.find('span#input_tag').replaceWith(element);

      const labelErrorField = $__default['default'](settings.label_tag);
      const errorMsgContainer = labelErrorField.find('span');
      const label = form.find("label[for='" + element.attr('id') + "']");
      label.append(errorMsgContainer);
      labelErrorField.insertAfter(label);
      labelErrorField.find('label#label_tag').replaceWith(label);
    }

    form.find("label[for='" + element.attr('id') + "'] > span.message")
        .text(message.replace(/\(.+\)/, '').trim());
  },
  remove: function remove(element, settings) {
    const form = $__default['default'](element[0].form);
    const inputErrorFieldClass = $__default['default'](settings.input_tag).attr('class');
    const inputErrorField = element.closest('.' + inputErrorFieldClass.replace(/ /g, '.'));
    const label = form.find("label[for='" + element.attr('id') + "']:not(.message)");
    const labelErrorFieldClass = $__default['default'](settings.label_tag).attr('class');
    const labelErrorField = label.closest('.' + labelErrorFieldClass.replace(/ /g, '.'));

    if (inputErrorField[0]) {
      inputErrorField.find('#' + element.attr('id')).detach();
      inputErrorField.replaceWith(element);
      label.find('span').remove();
      label.detach();
      labelErrorField.replaceWith(label);
    }
  }
}


/*************************
 * User D.O.B Validation *
 *************************/

const DATE_REGEX = /^\d{4}(-|\/)(0[1-9]|1[0-2])(-|\/)(0[1-9]|[12]\d|3[01])$/;

function shouldSetDobChanged() {
  const element = $('#user_dob');
  if (element.data('changed')) {
    return true;
  } else {
    return DATE_REGEX.test(element.val());
  }
}

const inputEventBindings = window.ClientSideValidations.eventsToBind.input;

// Enable validation for user d.o.b
ClientSideValidations.eventsToBind.input = function input(form) {
  const listeners = inputEventBindings(form);

  listeners['change.ClientSideValidations'] = function changeClientSideValidations() {
    const $element = $__default['default'](this);
    if (($element.attr('id') === 'user_dob' && shouldSetDobChanged()) ||
        $element.attr('id') !== 'user_dob') {
      $element.data('changed', true);
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

// Set error message for invalid user d.o.b
ClientSideValidations.validators.local['date'] = function(element, options) {
  if (!DATE_REGEX.test(element.val()) ||
      options['min'] && element.val() < options['min'] ||
      options['max'] && element.val() > options['max']) {
    return 'is invalid';
  }
}


/*****************
 * On DOM loaded *
 *****************/

function changePasswordValidationOrder() {
  const form = $__default['default']('form')[0];
  const validators = form.ClientSideValidations.settings.validators;

  const reOrdered = {
    presence: validators['user[password]'].presence,
    length: validators['user[password]'].length,
    format: validators['user[password]'].format,
    confirmation: validators['user[password]'].confirmation
  };

  validators['user[password]'] = reOrdered;
}

function changePasswordConfirmationKeyUpBehaviour() {
  const element = $('#user_password_confirmation');
  handler = jQuery._data(element[0], 'events').keyup[0].handler;

  element.off('keyup', handler);
  element.on('keyup', function () {
    $(this).data('interacted', true);
    handler();
  });
}

function changePasswordConfirmationFocusOutBehaviour() {
  const element = $('#user_password_confirmation');
  handler = jQuery._data(element[0], 'events').focusout[0].handler;

  element.off('focusout', handler);
  element.on('focusout', function () {
    if ($(this).data('interacted')) {
      handler();
    }
  });
}

$(document).on('turbolinks:load', function () {
  if ($('form[action="/register"]')[0]) {
    changePasswordValidationOrder();
    changePasswordConfirmationKeyUpBehaviour();
    changePasswordConfirmationFocusOutBehaviour();
  }
});
