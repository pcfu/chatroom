import { loginFns } from './login';
import { registerFns } from './register';

const FUNCS = {
  login: loginFns,
  register: registerFns
};

$(document).on('turbolinks:load', function () {
  const page = window.location.pathname.replace('/', '');
  if (FUNCS[page]) FUNCS[page]();
});
