// Generated by CoffeeScript 1.8.0
(function() {
  window.Game = (function() {
    Game.init = function() {
      return this.game = new Game();
    };

    function Game() {
      this.height = 60;
      this.width = 140;
      this.map = new Map(this, this.width, this.height);
      this.actors = [];
      this.display = new ROT.Display({
        width: this.width,
        height: this.height,
        spacing: 1.1,
        fontSize: 12
      });
      document.body.appendChild(this.display.getContainer());
      this.drawWholeMap();
      this.player = new Player(this, new Location(this, [70, 30]));
      this.spawner = new Spawner(this);
      this.spawner.spawn(1000);
      this.drawScore();
    }

    Game.prototype.drawWholeMap = function() {
      return _.each(this.map.locations(), (function(_this) {
        return function(location) {
          return _this.drawMapLocation(location);
        };
      })(this));
    };

    Game.prototype.drawMapLocation = function(location) {
      return this.draw(location, this.map.at(location));
    };

    Game.prototype.draw = function(location, character, color) {
      return location.drawOn(this.display, character, color);
    };

    Game.prototype.drawScore = function() {
      if (this.player != null) {
        return this.display.drawText(5, 0, "Score: " + this.player.score + " " + (this.spawner.level().constructor.name) + " Weapon: " + this.player.weapon.constructor.name);
      }
    };

    Game.prototype.enters = function(entity) {
      return _.each(entity.location.otherActors(entity), (function(_this) {
        return function(actor) {
          return actor.struckBy(entity);
        };
      })(this));
    };

    Game.prototype.died = function(entity) {
      this.actors = _.without(this.actors, entity);
      return entity.died();
    };

    Game.prototype.gameOver = function() {
      this.display.drawText(this.height / 2, 5, "You have died.  Game Over. Score: " + this.player.score + " Killed By A: " + this.player.destroyedBy + " Press [ESC] to restart");
      return window.addEventListener("keydown", this);
    };

    Game.prototype.handleEvent = function(e) {
      var code;
      code = e.keyCode;
      if (code === 27) {
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
