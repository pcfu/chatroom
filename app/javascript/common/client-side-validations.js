function _interopDefaultLegacy (e) {
  return e && typeof e === 'object' && 'default' in e ? e : { 'default': e };
}

const $__default = /*#__PURE__*/_interopDefaultLegacy($);


/***************************************
 * Adding and Removing form error tags *
 ***************************************/

ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] = {
  add: function add(element, settings, message) {
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


/************************************
 * Password Confirmation Validation *
 ************************************/

function validatePasswordConfirmation() {
  const element = $('#user_password')
  element.data({'changed': true, 'validateConfirmation': true});
  element.trigger('focusout');
  element.removeData('validateConfirmation');
}

function customConfirmationValidator(element, options) {
  const selector = '#' + element.attr('id') + '_confirmation';
  const confirmationValue = $__default['default'](selector).val();

  if (element.data('validateConfirmation') || confirmationValue.length > 0) {
    var value = element.val();

    if (!options.case_sensitive) {
      value = value.toLowerCase();
      confirmationValue = confirmationValue.toLowerCase();
    }

    if (value !== confirmationValue) {
      return options.message;
    }
  }
};

// Set custom conditions for validating password confirmation
ClientSideValidations.validators.local.confirmation = customConfirmationValidator;

// Force validation of password confirmation on submitting form
ClientSideValidations.callbacks.form.after = function(form, eventData) {
  validatePasswordConfirmation();
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

$(document).ready(function () {
  changePasswordValidationOrder();
});
