var plugin = function(){
  return function(style){
    style.define('random', function(a, b) {
      return Math.floor((Math.random() * ((b + 1) - a)) + a);
    });
  };
};
module.exports = plugin;
