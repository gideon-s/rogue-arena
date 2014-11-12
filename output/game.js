// Generated by CoffeeScript 1.8.0
(function() {
  window.Game = {
    display: null,
    map: new Map(ROT.DEFAULT_WIDTH, ROT.DEFAULT_HEIGHT),
    player: null,
    actors: [],
    prize: null,
    init: function() {
      this.display = new ROT.Display({
        spacing: 1.1
      });
      document.body.appendChild(this.display.getContainer());
      this.generateMap();
      this.drawWholeMap();
      this.player = new Player(this.map.randomLocation());
      return this.spawn();
    },
    generateMap: function() {
      var arena, arenaCallback;
      arena = new ROT.Map.Arena();
      arenaCallback = function(x, y, value) {
        if (value) {
          return;
        }
        return this.map.setLocation(new Location([x, y]), " ");
      };
      return arena.create(arenaCallback.bind(this));
    },
    generateBoxes: function(num) {
      return _.each(_.range(num), (function(_this) {
        return function() {
          var randLoc;
          randLoc = _this.map.randomLocation();
          _this.map.setLocation(randLoc, "*");
          if (_this.prize === null) {
            return _this.prize = randLoc;
          }
        };
      })(this));
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
    enters: function(entity) {
      return _.each(this.actors, (function(_this) {
        return function(actor) {
          if (actor !== entity && _.isEqual(actor.location, entity.location)) {
            return actor.struckBy(entity);
          }
        };
      })(this));
    },
    died: function(entity) {
      this.actors = _.without(this.actors, entity);
      return entity.died();
    },
    spawn: function() {
      this.actors.push(new Enemy(this.map.randomLocation()));
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
    }
  };

  Game.init();

}).call(this);
