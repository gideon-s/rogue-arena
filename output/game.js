// Generated by CoffeeScript 1.7.1
(function() {
  window.Game = (function() {
    Game.init = function() {
      return this.game = new Game();
    };

    function Game() {
      this.height = 60;
      this.width = 140;
      this.map = new Map(this, this.width, this.height - 1);
      this.actors = [];
      this.display = new ROT.Display({
        width: this.width,
        height: this.height,
        spacing: 1.1,
        fontSize: 12
      });
      document.body.appendChild(this.display.getContainer());
      this.drawWholeMap();
      this.player = new Player(this, this.map.lookupLocation([70, 30]));
      this.spawner = new Spawner(this);
      this.spawner.spawn(1000);
      this.drawScore();
    }

    Game.prototype.drawWholeMap = function() {
      return _.each(this.map.locations(), (function(_this) {
        return function(location) {
          return _this.draw(location);
        };
      })(this));
    };

    Game.prototype.draw = function(location) {
      if (location instanceof NoLocation) {
        throw new Error("not a real location?");
      }
      return location.drawOn(this.display);
    };

    Game.prototype.drawScore = function() {
      var text;
      if (this.player != null) {
        text = "Score: " + this.player.score;
        text += " " + (this.spawner.level().constructor.name);
        text += " MainWeapon " + this.player.weapons['main'].constructor.name;
        _.each(this.player.modKeys, (function(_this) {
          return function(mod) {
            var weapon;
            weapon = _this.player.weapons[mod];
            return text += " " + mod + "Weapon: " + (weapon != null ? weapon.constructor.name : 'none');
          };
        })(this));
        this.display.drawText(5, 0, text + (" " + this.actors.length + " ........................."), 1000);
        if (this.player.dead) {
          return this.display.drawText(this.height / 2, 5, "You have died.  Game Over. Score: " + this.player.score + " Killed By A: " + this.player.destroyedBy + " Press [ESC] to restart");
        }
      }
    };

    Game.prototype.died = function(entity) {
      return Util.removeFromArray(this.actors, entity);
    };

    Game.prototype.gameOver = function() {
      this.display.drawText(this.height / 2, 5, "You have died.  Game Over. Score: " + this.player.score + " Killed By A: " + this.player.destroyedBy + " Press [ESC] to restart");
      return window.addEventListener("keydown", this);
    };

    Game.prototype.handleEvent = function(e) {
      if (e.keyCode === ROT.VK_ESCAPE) {
        location.reload();
      }
    };

    Game.prototype.nextAction = function(action, speed) {
      return window.setTimeout((function() {
        return action();
      }), speed);
    };

    return Game;

  })();

}).call(this);
