// Generated by CoffeeScript 1.8.0
(function() {
  window.Util = (function() {
    function Util() {}

    Util.rand = function(highNumber) {
      return Math.floor(ROT.RNG.getUniform() * highNumber);
    };

    Util.pickRandom = function(list) {
      return list[this.rand(list.length)];
    };

    Util.isInteger = function(value) {
      return !isNaN(parseInt(value, 10)) && (parseFloat(value, 10) === parseInt(value, 10));
    };

    return Util;

  })();

  window.Coordinates = (function() {
    function Coordinates() {}

    Coordinates.parse = function(keyValue) {
      var parts, x, y;
      parts = keyValue.split(",");
      x = parseInt(parts[0]);
      y = parseInt(parts[1]);
      return [x, y];
    };

    Coordinates.create = function(xValue, yValue) {
      var keyValue;
      keyValue = xValue + ',' + yValue;
      return keyValue;
    };

    Coordinates.selectRandom = function(coordinateList) {
      var item, x, y, _ref;
      item = Util.pickRandom(coordinateList);
      _ref = this.parse(item), x = _ref[0], y = _ref[1];
      return [x, y];
    };

    return Coordinates;

  })();

}).call(this);
