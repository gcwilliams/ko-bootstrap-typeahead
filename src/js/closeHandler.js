define([], function() {

  "use strict";

  function isChildOf(parent, possibleChild) {
    if (parent === possibleChild) {
      return true;
    }
    if (possibleChild.parentNode == null) { // top of the DOM
      return false;
    }
    return isChildOf(parent, possibleChild.parentNode);
  }

  function createChildOfHandler(el, fn) {
    return function(e) {
      if (!isChildOf(el, e.srcElement)) {
        fn();
      }
    };
  }

  function createHandler(eventName, el, fn) {
    var fn = createChildOfHandler(el, fn);
    document.addEventListener(eventName, fn, true);
    return function() {
      document.removeEventListener(eventName, fn);
    };
  }

  return {
    create: function(el, fn) {
      var disposables = [], disposer;
      disposer = function() {
        disposables.forEach(function(fn) { fn(); });
        fn();
      };
      disposables.push(createHandler("click", el, disposer));
      disposables.push(createHandler("keypress", el, disposer));
      return disposer;
    }
  };
});