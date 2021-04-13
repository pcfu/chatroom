import { loginFns } from './login';
import { registerFns } from './register';

const fns = {
  login: loginFns,
  register: registerFns
};

$(document).on('turbolinks:load', function () {
  const page = window.location.pathname.replace('/', '');
  if (fns[page]) fns[page]();
});
