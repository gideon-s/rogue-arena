// Generated by CoffeeScript 1.7.1
(function() {
  window.Actor = (function() {
    function Actor(game, location, sigil, color, speed) {
      this.game = game;
      this.location = location;
      this.sigil = sigil;
      this.color = color;
      this.speed = speed;
      this.dead = false;
      this.game.actors.push(this);
      this.age = 0;
      this.action();
    }

    Actor.prototype.action = function() {
      this.age++;
      this.game.drawMapLocation(this.location);
      if ((this.game.player != null) && this.game.player.dead) {
        this.game.gameOver();
        return;
      }
      if (this.dead) {
        this.game.died(this);
        return;
      }
      this.act();
      if (this.dead) {
        this.game.died(this);
        return;
      }
      if (!this.game.map.isOpen(this.location)) {
        this.game.died(this);
        this.dead = true;
        return;
      }
      this.game.enters(this);
      this.draw();
      return this.game.nextAction(((function(_this) {
        return function() {
          return _this.action();
        };
      })(this)), this.speed);
    };

    Actor.prototype.died = function() {};

    Actor.prototype.act = function() {};

    Actor.prototype.draw = function() {
      return this.game.draw(this.location, this.sigil, this.color);
    };

    Actor.prototype.destroy = function() {
      return this.dead = true;
    };

    Actor.prototype.struckBy = function(entity) {
      if (entity instanceof RescueProjectile) {
        return;
      }
      if ((this.hits != null) && this.hits > 0) {
        this.hits -= 1;
      } else {
        this.dead = true;
        this.destroyedBy = entity.constructor.name;
      }
      if ((entity.hits != null) && entity.hits > 0) {
        return entity.hits -= 1;
      } else {
        entity.destroy();
        return entity.destroyedBy = this.constructor.name;
      }
    };

    return Actor;

  })();

  window.Colorizor = (function() {
    function Colorizor(colors) {
      this.colors = colors != null ? colors : ["yellow", "red", "orange"];
    }

    Colorizor.prototype.color = function() {
      return Util.pickRandom(this.colors);
    };

    return Colorizor;

  })();

}).call(this);
