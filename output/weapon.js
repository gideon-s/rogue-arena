// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Weapon = (function() {
    function Weapon(fireRate, owner) {
      this.fireRate = fireRate;
      this.owner = owner;
    }

    Weapon.prototype.fire = function(dirIndex) {
      var xyDir;
      if ((this.lastFired != null) && Util.millisSince(this.lastFired) < this.fireRate) {
        return;
      }
      xyDir = Util.xyDir(dirIndex);
      this.shoot(xyDir);
      return this.lastFired = Util.millis();
    };

    return Weapon;

  })();

  window.ControlledBlink = (function(_super) {
    __extends(ControlledBlink, _super);

    function ControlledBlink(owner) {
      ControlledBlink.__super__.constructor.call(this, 200, owner);
    }

    ControlledBlink.prototype.shoot = function(xyDir) {
      var destination;
      destination = this.owner.location.addDir(xyDir, 8);
      if (!this.owner.game.map.isOpen(destination)) {
        return;
      }
      this.owner.location = destination;
      this.owner.game.enters(this.owner);
      return this.owner.draw();
    };

    return ControlledBlink;

  })(window.Weapon);

  window.Dart = (function(_super) {
    __extends(Dart, _super);

    function Dart(owner) {
      Dart.__super__.constructor.call(this, 150, owner);
    }

    Dart.prototype.shoot = function(xyDir) {
      var nextLocation;
      nextLocation = this.owner.location.addDir(xyDir);
      return new Projectile(this.owner.game, nextLocation, xyDir, this.owner, "yellow", 20);
    };

    return Dart;

  })(window.Weapon);

  window.FireBall = (function(_super) {
    __extends(FireBall, _super);

    function FireBall(owner) {
      FireBall.__super__.constructor.call(this, 500, owner);
    }

    FireBall.prototype.shoot = function(xyDir) {
      var nextLocation;
      nextLocation = this.owner.location.addDir(xyDir);
      return new Ball(this.owner.game, nextLocation, xyDir, this.owner, "red", 20);
    };

    return FireBall;

  })(window.Weapon);

  window.FireWall = (function(_super) {
    __extends(FireWall, _super);

    function FireWall(owner) {
      FireWall.__super__.constructor.call(this, 2500, owner);
    }

    FireWall.prototype.makeCloud = function(loc) {
      return new UnmovingCloud(this.owner.game, loc);
    };

    FireWall.prototype.shoot = function(xyDir) {
      var leftTurn, main, spot;
      main = this.owner.location;
      main = main.addDir(xyDir, 5);
      leftTurn = [xyDir[1], -xyDir[0]];
      spot = main.addDir(leftTurn, 5);
      return _.times(10, (function(_this) {
        return function(n) {
          _this.makeCloud(spot);
          return spot = spot.subtractDir(leftTurn);
        };
      })(this));
    };

    return FireWall;

  })(window.Weapon);

  window.RescueRay = (function(_super) {
    __extends(RescueRay, _super);

    function RescueRay(owner) {
      RescueRay.__super__.constructor.call(this, 300, owner);
    }

    RescueRay.prototype.shoot = function(xyDir) {
      var nextLocation;
      nextLocation = this.owner.location.addDir(xyDir);
      return new RescueProjectile(this.owner.game, nextLocation, xyDir, this.owner, "white", 7);
    };

    return RescueRay;

  })(window.Weapon);

  window.MagicMissile = (function(_super) {
    __extends(MagicMissile, _super);

    function MagicMissile(owner) {
      MagicMissile.__super__.constructor.call(this, 400, owner);
    }

    MagicMissile.prototype.shoot = function(xyDir) {
      var nextLocation, projectile;
      nextLocation = this.owner.location.addDir(xyDir);
      projectile = new Projectile(this.owner.game, nextLocation, xyDir, this.owner, "white", 100);
      projectile.speed = 2;
      return projectile;
    };

    return MagicMissile;

  })(window.Weapon);

  window.SmokeTrail = (function(_super) {
    __extends(SmokeTrail, _super);

    function SmokeTrail(owner) {
      SmokeTrail.__super__.constructor.call(this, 200, owner);
    }

    SmokeTrail.prototype.shoot = function(xyDir) {
      var nextLocation, projectile, purples;
      nextLocation = this.owner.location.addDir(xyDir);
      purples = new Colorizor(["purple", "blue", "MediumAquamarine"]);
      projectile = new Particle(this.owner.game, nextLocation, this.owner, this.maxLife = 15, "purple", purples);
      projectile.speed = 1000;
      return projectile;
    };

    return SmokeTrail;

  })(window.Weapon);

  window.KnifeWall = (function(_super) {
    __extends(KnifeWall, _super);

    function KnifeWall(owner) {
      KnifeWall.__super__.constructor.call(this, 150, owner);
    }

    KnifeWall.prototype.shoot = function(xyDir) {
      var dir, nextLocation, _i, _results;
      nextLocation = this.owner.location.addDir(xyDir);
      _results = [];
      for (dir = _i = 0; _i <= 7; dir = ++_i) {
        _results.push(new Projectile(this.owner.game, nextLocation, Util.xyDir(dir), this.owner, "red", 3));
      }
      return _results;
    };

    return KnifeWall;

  })(window.Weapon);

}).call(this);
