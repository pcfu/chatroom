// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

const requireAll = (r) => r.keys().forEach(r);

import 'bootstrap';
import "@fortawesome/fontawesome-free/js/all";
require("@rails/ujs").start();
require("turbolinks").start();
require("@rails/activestorage").start();
require("channels");
// client-side-validations MUST come AFTER turbolinks
require('@client-side-validations/client-side-validations');

requireAll(require.context('common', true, /\.js$/));
require('static_pages');
require('chat');

// Include jQuery in global and window scope
const jQuery = require('jquery')
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
const images = require.context('../images', true);
const imagePath = (name) => images(name, true);

// Enable Bootstrap tooltips everywhere
$(function () {
  $('[data-toggle="tooltip"]').tooltip();
});

require('styles/application');
if (process.env.NODE_ENV === 'test') {
  require('styles/spec_setup/disable-animation');
}
