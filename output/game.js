// Generated by CoffeeScript 1.7.1
(function() {
  window.Game = {
    display: null,
    map: new Map(80, 25),
    player: null,
    actors: [],
    prize: null,
    init: function() {
      this.display = new ROT.Display({
        spacing: 1.1
      });
      document.body.appendChild(this.display.getContainer());
      this.drawWholeMap();
      this.player = new Player(this.map.randomLocation());
      this.spawn();
      return this.drawScore();
    },
    drawWholeMap: function() {
      return _.each(this.map.locations(), (function(_this) {
        return function(location) {
          return _this.drawMapLocation(location);
        };
      })(this));
    },
    drawMapLocation: function(location) {
      return this.draw(location, this.map.at(location));
    },
    draw: function(location, character, color) {
      return location.drawOn(this.display, character, color);
    },
    drawScore: function() {
      return Game.display.drawText(5, 0, "Score: " + this.player.score);
    },
    enters: function(entity) {
      console.log("entity " + entity);
      console.log("" + entity.location);
      return _.each(entity.location.otherActors(entity), (function(_this) {
        return function(actor) {
          return actor.struckBy(entity);
        };
      })(this));
    },
    died: function(entity) {
      this.actors = _.without(this.actors, entity);
      return entity.died();
    },
    spawn: function() {
      this.actors.push(new Enemy(Game, this.map.randomEdgeLocation()));
      return window.setTimeout(((function(_this) {
        return function() {
          return _this.spawn();
        };
      })(this)), 1000);
    },
    gameOver: function() {
      Game.display.drawText(5, 5, "You have died.  Game Over. Score: " + this.player.score + " Press [ESC] to restart");
      return window.addEventListener("keydown", this);
    },
    handleEvent: function(e) {
      var code;
      code = e.keyCode;
      if (code === 27) {
        location.reload();
      }
    },
    nextAction: function(action, speed) {
      return window.setTimeout((function() {
        return action();
      }), speed);
    }
  };

  Game.init();

}).call(this);
