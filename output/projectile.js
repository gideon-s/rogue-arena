// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Projectile = (function(_super) {
    __extends(Projectile, _super);

    function Projectile(location, direction) {
      this.direction = direction;
      Projectile.__super__.constructor.call(this, location, "+", "yellow", 190);
    }

    Projectile.prototype.act = function() {
      return this.location = this.location.addDir(this.direction);
    };

    return Projectile;

  })(window.Actor);

}).call(this);
