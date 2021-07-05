import { loginFns } from './login';
import { registerFns } from './register';
import { chatFns } from './chat';

const FUNCS = {
  login: loginFns,
  register: registerFns,
  chat: chatFns
};

$(document).on('turbolinks:load', function () {
  const page = window.location.pathname.replace('/', '');
  if (FUNCS[page]) FUNCS[page]();
});
