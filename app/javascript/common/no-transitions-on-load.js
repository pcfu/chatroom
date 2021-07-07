export function noTransitionsOnLoad(elem) {
  let timeout;
  timeout = setTimeout(function () {
    elem.removeClass('no-transitions-on-load');
    clearTimeout(timeout);
  }, 100);
}
