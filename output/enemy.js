// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Enemy = (function(_super) {
    __extends(Enemy, _super);

    function Enemy(game, location, sigil, color, speed, score) {
      this.score = score != null ? score : 1;
      Enemy.__super__.constructor.call(this, game, location, sigil, color, speed);
    }

    Enemy.prototype.act = function() {
      var next;
      next = this.nextLocation();
      if ((next != null) && !((next instanceof Location) || (next instanceof NoLocation))) {
        throw new Error("nextLocation returned " + next.constructor.name + " instead of location!");
      }
      if ((next != null) && !next.hasOtherActorType(this, Enemy)) {
        return this.moveTo(next);
      }
    };

    Enemy.prototype.nextLocation = function() {
      return this.location;
    };

    Enemy.prototype.died = function(reason) {
      Enemy.__super__.died.call(this, reason);
      this.game.player.addScore(this.score);
      if (Util.oneIn(2)) {
        return new Item(this.game, this.location);
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
      return this.locationDistance(this.game.player.location);
    };

    Enemy.prototype.playerXYDirection = function(topology) {
      return this.actorXYDirection(topology, this.game.player);
    };

    return Enemy;

  })(window.Actor);

  window.Gridbug = (function(_super) {
    __extends(Gridbug, _super);

    function Gridbug(game, location, steps, sigil, score) {
      this.steps = steps != null ? steps : 5;
      if (sigil == null) {
        sigil = "x";
      }
      if (score == null) {
        score = 2;
      }
      Gridbug.__super__.constructor.call(this, game, location, sigil, "green", 50, score);
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

    return Gridbug;

  })(window.Enemy);

  window.GridBoss = (function(_super) {
    __extends(GridBoss, _super);

    function GridBoss(game, location) {
      var score, sigil;
      GridBoss.__super__.constructor.call(this, game, location, 10, sigil = "X", score = 20);
      this.hits = 10;
    }

    GridBoss.prototype.calculateNextStep = function() {
      var dir, firstLocation, xyDir, _i;
      for (dir = _i = 0; _i <= 7; dir = _i += 2) {
        xyDir = Util.xyDir(dir);
        firstLocation = this.location.addDir(xyDir);
        if (firstLocation.isOpen()) {
          new Projectile(this.game, firstLocation, this, 20, "+", "red", 20, xyDir);
        }
      }
      return GridBoss.__super__.calculateNextStep.call(this);
    };

    return GridBoss;

  })(window.Gridbug);

  window.ElvenArcher = (function(_super) {
    __extends(ElvenArcher, _super);

    function ElvenArcher(game, location) {
      var score;
      ElvenArcher.__super__.constructor.call(this, game, location, "E", "blue", 200, score = 10);
      this.hits = 2;
    }

    ElvenArcher.prototype.fire = function() {
      var dir, firstLocation;
      dir = this.playerXYDirection(8);
      firstLocation = this.location.addDir(dir);
      if (firstLocation.isOpen()) {
        new Projectile(this.game, firstLocation, this, 30, "+", "cyan", 20, dir);
      }
      return void 0;
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

    return ElvenArcher;

  })(window.Enemy);

  window.MinorDemon = (function(_super) {
    __extends(MinorDemon, _super);

    function MinorDemon(game, location, color, speed, score) {
      if (color == null) {
        color = "red";
      }
      if (speed == null) {
        speed = 400;
      }
      if (score == null) {
        score = 1;
      }
      MinorDemon.__super__.constructor.call(this, game, location, "&", color, speed, score);
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

  window.PufferDemon = (function(_super) {
    __extends(PufferDemon, _super);

    function PufferDemon(game, location) {
      var score;
      PufferDemon.__super__.constructor.call(this, game, location, "DarkRed", 200, score = 7);
    }

    PufferDemon.prototype.died = function(reason) {
      PufferDemon.__super__.died.call(this, reason);
      return new Ball(this.game, this.location, [0, 0], this, 30);
    };

    return PufferDemon;

  })(window.MinorDemon);

  window.MajorDemon = (function(_super) {
    __extends(MajorDemon, _super);

    function MajorDemon(game, location) {
      MajorDemon.__super__.constructor.call(this, game, location, "Lime", 50, 5);
    }

    MajorDemon.prototype.nextLocation = function() {
      var smokeLocation;
      if (Util.oneIn(3)) {
        smokeLocation = this.awayFromPlayer();
        new Particle(this.game, smokeLocation, this, Util.rand(5) + 3, Colors.poison, 200);
      }
      return MajorDemon.__super__.nextLocation.call(this);
    };

    return MajorDemon;

  })(window.MinorDemon);

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
      Citizen.__super__.constructor.call(this, game, loc, "@", "cyan", 100, 10);
    }

    Citizen.prototype.nextLocation = function() {
      if (Util.oneIn(3)) {
        return this.randomDirection();
      }
    };

    Citizen.prototype.hitBy = function(entity) {
      if (entity === this.game.player) {
        this.died("Saved!");
        return;
      }
      if (entity instanceof RescueProjectile) {
        this.died("Saved!");
        return;
      }
      if ((entity.owner != null) && entity.owner === this.game.player) {
        this.game.player.died("shooting a townie! Don't shoot the populace!");
        this.died("player projectile!");
        return;
      }
      return Citizen.__super__.hitBy.call(this, entity);
    };

    return Citizen;

  })(window.Enemy);

  window.Firebat = (function(_super) {
    __extends(Firebat, _super);

    function Firebat(game, location) {
      this.moves = [];
      Firebat.__super__.constructor.call(this, game, location, "w", "orange", 50, 5);
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
      var smokeLocation;
      smokeLocation = this.randomDirection();
      if (smokeLocation.isOpen()) {
        new Particle(this.game, smokeLocation, this, Util.rand(5) + 3, Colors.fire, 200);
      }
      return void 0;
    };

    return Firebat;

  })(window.Enemy);

  window.OrcCharger = (function(_super) {
    __extends(OrcCharger, _super);

    function OrcCharger(game, location, score) {
      if (score == null) {
        score = 3;
      }
      OrcCharger.__super__.constructor.call(this, game, location, "o", "white", 100, score);
    }

    OrcCharger.prototype.nextLocation = function() {
      if (this.playerDistance() < 20) {
        return this.towardsPlayer();
      } else {
        return this.randomDirection();
      }
    };

    return OrcCharger;

  })(window.Enemy);

  window.OrcBoss = (function(_super) {
    __extends(OrcBoss, _super);

    function OrcBoss(game, location) {
      this.hits = 20;
      OrcBoss.__super__.constructor.call(this, game, location, 50);
      this.color = "white";
      this.sigil = "O";
      this.charging = false;
    }

    OrcBoss.prototype.nextLocation = function() {
      if (this.hits < 18) {
        this.charging = true;
      }
      if (this.playerDistance() < 20 || this.charging) {
        return this.towardsPlayer();
      } else {
        return this.randomDirection();
      }
    };

    return OrcBoss;

  })(window.OrcCharger);

  window.Ghost = (function(_super) {
    __extends(Ghost, _super);

    function Ghost(game, location) {
      this.hits = 100;
      Ghost.__super__.constructor.call(this, game, location, "@", "DimGray", 500);
    }

    Ghost.prototype.nextLocation = function() {
      var l;
      l = this.randomDirection();
      this.game.player.location = l;
      return l;
    };

    return Ghost;

  })(window.Enemy);

}).call(this);
