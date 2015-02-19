// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Enemy = (function(_super) {
    __extends(Enemy, _super);

    function Enemy(game, location, sigil, color, speed) {
      Enemy.__super__.constructor.call(this, game, location, sigil, color, speed);
    }

    Enemy.prototype.act = function() {
      var next;
      next = this.nextLocation();
      if ((next != null) && !next.hasOtherActorType(this, Enemy)) {
        return this.moveTo(next);
      }
    };

    Enemy.prototype.nextLocation = function() {
      return this.location;
    };

    Enemy.prototype.died = function() {
      Enemy.__super__.died.apply(this, arguments);
      if (!this.game.player.dead) {
        return this.game.player.addScore();
      }
    };

    Enemy.prototype.towardsPlayer = function() {
      return this.location.addDir(this.playerXYDirection(8));
    };

    Enemy.prototype.awayFromPlayer = function() {
      return this.location.subtractDir(this.playerXYDirection(8));
    };

    Enemy.prototype.randomDirection = function() {
      return this.location.addDir(Util.rand8Dir());
    };

    Enemy.prototype.playerDistance = function() {
      return Util.distance(this.location, this.game.player.location);
    };

    Enemy.prototype.playerXYDirection = function(topology) {
      var absXDiff, absYDiff, xDiff, xDir, yDiff, yDir;
      xDiff = this.game.player.location.x - this.location.x;
      yDiff = this.game.player.location.y - this.location.y;
      absXDiff = Math.abs(xDiff);
      absYDiff = Math.abs(yDiff);
      xDir = absXDiff > 0 ? xDiff / absXDiff : 0;
      yDir = absYDiff > 0 ? yDiff / absYDiff : 0;
      if (topology === 4) {
        if (absXDiff > absYDiff) {
          return [xDir, 0];
        } else {
          return [0, yDir];
        }
      } else {
        return [xDir, yDir];
      }
    };

    return Enemy;

  })(window.Actor);

  window.Gridbug = (function(_super) {
    __extends(Gridbug, _super);

    function Gridbug(game, location, steps, sigil) {
      this.steps = steps != null ? steps : 5;
      if (sigil == null) {
        sigil = "x";
      }
      Gridbug.__super__.constructor.call(this, game, location, sigil, "green", 50);
      this.direction = null;
      this.stepsLeft = 0;
    }

    Gridbug.prototype.nextLocation = function() {
      if (this.stepsLeft === 0) {
        this.calculateNextStep();
      }
      this.stepsLeft -= 1;
      if (this.direction != null) {
        return this.location.addDir(this.direction);
      }
    };

    Gridbug.prototype.calculateNextStep = function() {
      if (this.direction != null) {
        this.direction = null;
        return this.stepsLeft = this.steps;
      } else {
        this.direction = this.playerXYDirection(4);
        return this.stepsLeft = this.steps;
      }
    };

    Gridbug.prototype.died = function() {
      Gridbug.__super__.died.apply(this, arguments);
      return this.game.player.addScore(2);
    };

    return Gridbug;

  })(window.Enemy);

  window.GridBoss = (function(_super) {
    __extends(GridBoss, _super);

    function GridBoss(game, location) {
      var sigil;
      GridBoss.__super__.constructor.call(this, game, location, 10, sigil = "X");
      this.hits = 10;
    }

    GridBoss.prototype.calculateNextStep = function() {
      var dir, firstLocation, xyDir, _i;
      for (dir = _i = 0; _i <= 7; dir = _i += 2) {
        xyDir = Util.xyDir(dir);
        firstLocation = this.location.addDir(xyDir);
        if (firstLocation.isOpen()) {
          new Projectile(this.game, firstLocation, xyDir, this, "red", 20);
        }
      }
      return GridBoss.__super__.calculateNextStep.call(this);
    };

    GridBoss.prototype.struckBy = function(entity) {
      this.hits -= 1;
      if (entity !== this.game.player && this.hits > 0) {
        return;
      }
      return GridBoss.__super__.struckBy.call(this, entity);
    };

    GridBoss.prototype.died = function() {
      GridBoss.__super__.died.apply(this, arguments);
      return this.game.player.addScore(20);
    };

    return GridBoss;

  })(window.Gridbug);

  window.ElvenArcher = (function(_super) {
    __extends(ElvenArcher, _super);

    function ElvenArcher(game, location) {
      ElvenArcher.__super__.constructor.call(this, game, location, "E", "blue", 200);
      this.hits = 4;
    }

    ElvenArcher.prototype.fire = function() {
      var dir, firstLocation;
      dir = this.playerXYDirection(8);
      firstLocation = this.location.addDir(dir);
      if (firstLocation.isOpen()) {
        return new Projectile(this.game, firstLocation, dir, this, "cyan", 30);
      }
    };

    ElvenArcher.prototype.nextLocation = function() {
      if (this.playerDistance() > 20) {
        if (Util.oneIn(2)) {
          return this.towardsPlayer();
        } else if (Util.oneIn(3)) {
          return this.fire();
        } else {
          return this.randomDirection();
        }
      } else if (this.playerDistance() < 10) {
        if (Util.oneIn(2)) {
          return this.awayFromPlayer();
        } else if (Util.oneIn(5)) {
          return this.randomDirection();
        } else {
          return this.fire();
        }
      } else {
        if (Util.oneIn(5)) {
          return this.fire();
        } else {
          return this.randomDirection();
        }
      }
    };

    ElvenArcher.prototype.died = function() {
      ElvenArcher.__super__.died.apply(this, arguments);
      return this.game.player.addScore(10);
    };

    ElvenArcher.prototype.struckBy = function(entity) {
      this.hits -= 1;
      if (entity !== this.game.player && this.hits > 0) {
        return;
      }
      return ElvenArcher.__super__.struckBy.call(this, entity);
    };

    return ElvenArcher;

  })(window.Enemy);

  window.MinorDemon = (function(_super) {
    __extends(MinorDemon, _super);

    function MinorDemon(game, location) {
      MinorDemon.__super__.constructor.call(this, game, location, "&", "red", 400);
    }

    MinorDemon.prototype.nextLocation = function() {
      if (Util.oneIn(3)) {
        return this.randomDirection();
      } else {
        return this.towardsPlayer();
      }
    };

    return MinorDemon;

  })(window.Enemy);

  window.Citizen = (function(_super) {
    __extends(Citizen, _super);

    function Citizen(game, location) {
      var loc;
      while (true) {
        loc = game.map.randomLocation();
        if (Util.distance(loc, game.player.location) > 20) {
          break;
        }
      }
      Citizen.__super__.constructor.call(this, game, loc, "@", "cyan", 100);
    }

    Citizen.prototype.nextLocation = function() {
      if (Util.oneIn(3)) {
        return this.randomDirection();
      }
    };

    Citizen.prototype.died = function() {
      Citizen.__super__.died.apply(this, arguments);
      return this.game.player.addScore(10);
    };

    Citizen.prototype.struckBy = function(entity) {
      if (entity === this.game.player) {
        this.dead = true;
        return;
      }
      if (entity instanceof RescueProjectile) {
        this.dead = true;
        return;
      }
      if (entity instanceof Projectile || entity instanceof Particle) {
        if (entity.owner === this.game.player) {
          this.game.player.destroy();
          return this.game.player.destroyedBy = this.constructor.name;
        }
      }
    };

    return Citizen;

  })(window.Enemy);

  window.Firebat = (function(_super) {
    __extends(Firebat, _super);

    function Firebat(game, location) {
      this.moves = [];
      Firebat.__super__.constructor.call(this, game, location, "w", "orange", 50);
    }

    Firebat.prototype.nextLocation = function() {
      if (this.moves.length !== 0) {
        return this.nextFlap();
      } else {
        if (Util.oneIn(2)) {
          return this.fire();
        } else if (Util.oneIn(4)) {
          return this.towardsPlayer();
        } else if (Util.oneIn(6)) {
          return this.startFlapAround();
        } else {
          return this.randomDirection();
        }
      }
    };

    Firebat.prototype.startFlapAround = function() {
      this.moves = [1, 1, 3, 3, 5, 5, 7, 7];
      if (Util.oneIn(2)) {
        this.moves.reverse();
      }
      return this.nextFlap();
    };

    Firebat.prototype.nextFlap = function() {
      var dir;
      dir = this.moves.shift();
      return this.location.addDir(Util.xyDir(dir));
    };

    Firebat.prototype.fire = function() {
      var smoke, smokeLocation;
      smokeLocation = this.randomDirection();
      if (smokeLocation.isOpen()) {
        smoke = new Particle(this.game, smokeLocation, this, Util.rand(5));
        smoke.speed = 300;
      }
      return void 0;
    };

    Firebat.prototype.died = function() {
      Firebat.__super__.died.apply(this, arguments);
      return this.game.player.addScore(5);
    };

    return Firebat;

  })(window.Enemy);

  window.OrcCharger = (function(_super) {
    __extends(OrcCharger, _super);

    function OrcCharger(game, location) {
      OrcCharger.__super__.constructor.call(this, game, location, "o", "white", 100);
    }

    OrcCharger.prototype.nextLocation = function() {
      if (this.playerDistance() < 20) {
        return this.towardsPlayer();
      } else {
        return this.randomDirection();
      }
    };

    OrcCharger.prototype.died = function() {
      OrcCharger.__super__.died.apply(this, arguments);
      return this.game.player.addScore(3);
    };

    return OrcCharger;

  })(window.Enemy);

  window.OrcBoss = (function(_super) {
    __extends(OrcBoss, _super);

    function OrcBoss(game, location) {
      this.hits = 30;
      OrcBoss.__super__.constructor.call(this, game, location);
      this.color = "cyan";
      this.sigil = "O";
    }

    OrcBoss.prototype.died = function() {
      OrcBoss.__super__.died.apply(this, arguments);
      return this.game.player.addScore(50);
    };

    OrcBoss.prototype.struckBy = function(entity) {
      this.hits -= 1;
      if (entity !== this.game.player && this.hits > 0) {
        return;
      }
      return OrcBoss.__super__.struckBy.call(this, entity);
    };

    return OrcBoss;

  })(window.OrcCharger);

}).call(this);
