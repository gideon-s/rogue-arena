// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Gridbug = (function(_super) {
    __extends(Gridbug, _super);

    function Gridbug(game, location) {
      Gridbug.__super__.constructor.call(this, game, location, "X", "green", 50);
      this.direction = null;
      this.stepsLeft = 0;
    }

    Gridbug.prototype.nextLocation = function() {
      if (this.stepsLeft === 0) {
        this.calculateNextStep();
      }
      this.stepsLeft = this.stepsLeft - 1;
      if (this.direction != null) {
        return this.location.addDir(this.direction);
      } else {
        return this.location;
      }
    };

    Gridbug.prototype.calculateNextStep = function() {
      var nextLocation;
      if (this.direction != null) {
        this.direction = null;
        return this.stepsLeft = 5;
      } else {
        nextLocation = this.location.nextStepToDestination(this.game.player.location, this.game.map, 4);
        this.direction = [nextLocation.x - this.location.x, nextLocation.y - this.location.y];
        return this.stepsLeft = 3;
      }
    };

    return Gridbug;

  })(window.Enemy);

}).call(this);