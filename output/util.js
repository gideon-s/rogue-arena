// Generated by CoffeeScript 1.7.1
(function() {
  window.Util = (function() {
    function Util() {}

    Util.rotate = function(a) {
      var newLast;
      newLast = a.shift();
      a.push(newLast);
      return newLast;
    };

    Util.rand = function(highNumber) {
      return Math.floor(ROT.RNG.getUniform() * highNumber);
    };

    Util.pickRandom = function(list) {
      return list[this.rand(list.length)];
    };

    Util.oneIn = function(number) {
      return Util.rand(number) === 0;
    };

    Util.rand8Dir = function() {
      return ROT.DIRS[8][Util.rand(8)];
    };

    Util.rand4Dir = function() {
      return ROT.DIRS[4][Util.rand(4)];
    };

    Util.millis = function() {
      return new Date().getTime();
    };

    Util.millisSince = function(otherMillis) {
      return Util.millis() - otherMillis;
    };

    Util.xyDir = function(dirIndex, topology) {
      if (topology == null) {
        topology = 8;
      }
      return ROT.DIRS[topology][dirIndex];
    };

    Util.leftTurn = function(xyDir) {
      return [xyDir[1], -xyDir[0]];
    };

    Util.rightTurn = function(xyDir) {
      return [-xyDir[1], xyDir[0]];
    };

    Util.distance = function(l1, l2) {
      var xDiff, yDiff;
      xDiff = l1.x - l2.x;
      yDiff = l1.y - l2.y;
      return Math.floor(Math.sqrt((xDiff * xDiff) + (yDiff * yDiff)));
    };

    Util.removeFromArray = function(array, o) {
      var index;
      index = array.indexOf(o);
      if (index < 0) {
        console.log(o);
        console.log(array);
        throw new Error("" + o + " not found in array: " + array);
      }
      return array.splice(index, 1);
    };

    return Util;

  })();

}).call(this);
