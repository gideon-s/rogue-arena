// Generated by CoffeeScript 1.8.0
(function() {
  window.Actor = (function() {
    function Actor(game, location, sigil, color, speed) {
      this.game = game;
      this.location = location;
      this.sigil = sigil;
      this.color = color;
      this.speed = speed;
      this.id = this.game.nextActorId();
      this.dead = false;
      if (this.location instanceof NoLocation) {
        return;
      }
      this.game.actors.push(this);
      this.location.arriving(this);
      this.action();
    }

    Actor.prototype.action = function() {
      if (this.colorizor != null) {
        this.color = this.colorizor.color();
        this.game.draw(this.location);
      }
      if ((this.game.player != null) && this.game.player.dead) {
        this.game.gameOver();
      }
      if (!this.dead) {
        this.act();
      }
      if ((this.game.halt != null) && this.game.halt) {
        return;
      }
      if (!this.dead) {
        return this.game.nextAction(((function(_this) {
          return function() {
            return _this.action();
          };
        })(this)), this.speed);
      }
    };

    Actor.prototype.died = function(reason) {
      this.dead = true;
      this.destroyedBy = reason;
      this.location.leaving(this);
      return this.game.died(this);
    };

    Actor.prototype.act = function() {};

    Actor.prototype.hitBy = function(entity, hitBack) {
      hitBack = hitBack ? " in hit back" : " in initial hit";
      if (entity instanceof RescueProjectile) {
        return;
      }
      if ((entity.owner != null) && this === entity.owner) {
        return;
      }
      if ((this.owner != null) && this.owner === entity) {
        this.died("struck owner" + hitBack);
        return;
      }
      if ((this.hits != null) && this.hits > 0) {
        return this.hits -= 1;
      } else {
        return this.died(entity.constructor.name + hitBack);
      }
    };

    Actor.prototype.struckBy = function(entity) {
      this.hitBy(entity, false);
      return entity.hitBy(this, true);
    };

    Actor.prototype.moveTo = function(newLocation) {
      if (newLocation == null) {
        return;
      }
      newLocation.struckBy(this);
      if (!this.dead && newLocation.isOpen()) {
        this.location.leaving(this);
        this.location = newLocation;
        return this.location.arriving(this);
      }
    };

    Actor.prototype.locationDistance = function(location) {
      return Util.distance(this.location, location);
    };

    Actor.prototype.actorXYDirection = function(topology, actor) {
      var absXDiff, absYDiff, xDiff, xDir, yDiff, yDir;
      xDiff = actor.location.x - this.location.x;
      yDiff = actor.location.y - this.location.y;
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

    return Actor;

  })();

}).call(this);
