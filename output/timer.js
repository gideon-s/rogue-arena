// Generated by CoffeeScript 1.8.0
(function() {
  window.Timer = (function() {
    function Timer() {}

    Timer.prototype.nextAction = function(speed, action) {
      this.speed = speed;
      this.action = action;
      return window.setTimeout(((function(_this) {
        return function() {
          return _this.action();
        };
      })(this)), this.speed);
    };

    return Timer;

  })();

}).call(this);
