function _interopDefaultLegacy (e) {
  return e && typeof e === 'object' && 'default' in e ? e : { 'default': e };
}

const $__default = /*#__PURE__*/_interopDefaultLegacy($);

function initTemp() {
  if (!window.temp) { window.temp = []; }
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
