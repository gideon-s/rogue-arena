// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Projectile = (function(_super) {
    __extends(Projectile, _super);

    function Projectile(game, location, direction, owner, color, maxLife) {
      this.direction = direction;
      this.owner = owner;
      if (color == null) {
        color = "yellow";
      }
      this.maxLife = maxLife != null ? maxLife : 1000;
      Projectile.__super__.constructor.call(this, game, location, "+", color, 20);
    }

    Projectile.prototype.act = function() {
      var nextLoc;
      nextLoc = this.location.addDir(this.direction);
      this.maxLife = this.maxLife - 1;
      if (nextLoc.hasOtherActor(this, this.owner) || this.maxLife < 0) {
        this.dead = true;
        return;
      }
      return this.location = nextLoc;
    };

    Projectile.prototype.struckBy = function(entity) {
      if (entity === this.owner) {
        return;
      }
      return Projectile.__super__.struckBy.call(this, entity);
    };

    return Projectile;

  })(window.Actor);

  window.Particle = (function(_super) {
    __extends(Particle, _super);

    function Particle(game, location, owner, maxLife, color, colorizor) {
      this.owner = owner;
      this.maxLife = maxLife != null ? maxLife : Util.rand(20);
      if (color == null) {
        color = "yellow";
      }
      this.colorizor = colorizor != null ? colorizor : new Colorizor();
      Particle.__super__.constructor.call(this, game, location, "#", color, 20);
    }

    Particle.prototype.act = function() {
      var nextLoc;
      this.color = this.colorizor.color();
      nextLoc = this.location.addDir(Util.rand8Dir());
      this.maxLife = this.maxLife - 1;
      if (nextLoc.hasOtherActorType(this, Particle) || this.maxLife < 0 || nextLoc.hasOtherActor(this, this.owner)) {
        this.dead = true;
        return;
      }
      return this.location = nextLoc;
    };

    Particle.prototype.struckBy = function(entity) {
      if ((entity instanceof Particle) || (entity === this.owner)) {
        return;
      }
      return Particle.__super__.struckBy.call(this, entity);
    };

    return Particle;

  })(window.Actor);

  window.Ball = (function(_super) {
    __extends(Ball, _super);

    function Ball(game, location, direction, owner, color, maxLife) {
      if (color == null) {
        color = "white";
      }
      if (maxLife == null) {
        maxLife = 30;
      }
      this.colorizor = new Colorizor();
      Ball.__super__.constructor.call(this, game, location, direction, owner, color, maxLife);
    }

    Ball.prototype.act = function() {
      this.color = this.colorizor.color();
      return Ball.__super__.act.call(this);
    };

    Ball.prototype.died = function() {
      var dir, firstLocation, xyDir, _i, _results;
      _results = [];
      for (dir = _i = 0; _i <= 7; dir = ++_i) {
        xyDir = Util.xyDir(dir);
        firstLocation = this.location.addDir(xyDir);
        _results.push(this.emit(firstLocation, xyDir));
      }
      return _results;
    };

    Ball.prototype.emit = function(firstLocation, xyDir) {
      return new BallParticle(this.game, firstLocation, xyDir, this.owner, "red", 2);
    };

    return Ball;

  })(window.Projectile);

  window.BallParticle = (function(_super) {
    __extends(BallParticle, _super);

    function BallParticle() {
      return BallParticle.__super__.constructor.apply(this, arguments);
    }

    BallParticle.prototype.emit = function(firstLocation, xyDir) {
      return new Particle(this.game, firstLocation, this.owner, Util.rand(5));
    };

    return BallParticle;

  })(window.Ball);

}).call(this);
