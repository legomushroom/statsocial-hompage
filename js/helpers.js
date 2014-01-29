// Generated by CoffeeScript 1.6.2
(function() {
  var Helpers, _ref;

  Helpers = (function() {
    function Helpers() {}

    Helpers.prototype.bind = function(func, context) {
      var bindArgs, wrapper;

      wrapper = function() {
        var args, unshiftArgs;

        args = Array.prototype.slice.call(arguments);
        unshiftArgs = bindArgs.concat(args);
        return func.apply(context, unshiftArgs);
      };
      bindArgs = Array.prototype.slice.call(arguments, 2);
      return wrapper;
    };

    Helpers.prototype.extend = function(obj, obj2) {
      var key, value;

      for (key in obj2) {
        value = obj2[key];
        if (obj2[key] != null) {
          obj[key] = value;
        }
      }
      return obj;
    };

    return Helpers;

  })();

  if ((_ref = window.StatSocial) == null) {
    window.StatSocial = {};
  }

  window.StatSocial.helpers = new Helpers;

}).call(this);

/*
//@ sourceMappingURL=helpers.map
*/
