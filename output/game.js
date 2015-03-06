// Generated by CoffeeScript 1.8.0
(function() {
  window.Game = (function() {
    Game.init = function() {
      return this.game = new Game();
    };

    function Game() {
      this.actorId = 0;
      this.height = Math.floor($(window).height() / 15) - 1;
      this.width = Math.floor($(window).width() / 9);
      this.map = new Map(this, this.width, this.height - 1);
      this.actors = [];
      this.display = new ROT.Display({
        width: this.width,
        height: this.height + 2,
        spacing: 1.1,
        fontSize: 12
      });
      $('#game').append(this.display.getContainer());
      this.drawWholeMap();
      this.player = new Player(this, this.map.lookupLocation([Math.floor(this.width / 2), Math.floor(this.height / 2)]));
      this.spawner = new Spawner(this);
      this.spawner.spawn(1000);
      this.drawScore();
    }

    Game.prototype.nextActorId = function() {
      this.actorId += 1;
      return this.actorId;
    };

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
        text = "";
        if (this.player.hits != null) {
          text += "Hits: " + this.player.hits;
        }
        text += " Score: " + this.player.score;
        text += " " + (this.spawner.level().constructor.name);
        text += " W: " + this.player.weapons['main'].constructor.name;
        _.each(this.player.modKeys, (function(_this) {
          return function(mod) {
            var weapon;
            weapon = _this.player.weapons[mod];
            return text += " " + (mod.substring(0, 4)) + "W: " + (weapon != null ? weapon.constructor.name : 'none');
          };
        })(this));
        this.display.drawText(5, 0, text + (" " + this.actors.length + " ........................."), 1000);
        if (this.player.dead) {
          return this.display.drawText(30, 5, "You have died.  Game Over. Score: " + this.player.score + " Killed By A: " + this.player.destroyedBy + " Press [ESC] to restart");
        }
      }
    };

    Game.prototype.died = function(entity) {
      return Util.removeFromArray(this.actors, entity);
    };

    Game.prototype.gameOver = function() {
      this.display.drawText(30, 5, "You have died.  Game Over. Score: " + this.player.score + " Killed By A: " + this.player.destroyedBy + " Press [ESC] to restart");
      return window.addEventListener("keydown", this);
    };

    Game.prototype.handleEvent = function(e) {
      if (e.keyCode === ROT.VK_ESCAPE) {
        location.reload();
      }
    };

    Game.prototype.nextAction = function(action, speed) {
      if (speed == null) {
        throw new Error("can't set timeout immediately!");
      }
      if (speed < 5) {
        throw new Error("speed too low!");
      }
      return window.setTimeout((function() {
        return action();
      }), speed);
    };

    return Game;

  })();

}).call(this);
