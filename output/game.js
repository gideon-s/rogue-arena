// Generated by CoffeeScript 1.7.1
(function() {
  window.Game = {
    display: null,
    map: new Map(ROT.DEFAULT_WIDTH, ROT.DEFAULT_HEIGHT),
    engine: null,
    player: null,
    dragon: null,
    prize: null,
    init: function() {
      var scheduler;
      this.display = new ROT.Display({
        spacing: 1.1
      });
      document.body.appendChild(this.display.getContainer());
      this.generateMap();
      this.generateBoxes(10);
      this.drawWholeMap();
      this.player = new Player(this.map.randomLocation());
      this.dragon = new Enemy(this.map.randomLocation());
      scheduler = new ROT.Scheduler.Simple();
      scheduler.add(this.player, true);
      scheduler.add(this.dragon, true);
      this.engine = new ROT.Engine(scheduler);
      return this.engine.start();
    },
    generateMap: function() {
      var digCallback, digger;
      digger = new ROT.Map.Digger();
      digCallback = function(x, y, value) {
        if (value) {
          return;
        }
        return this.map.setLocation(new Location([x, y]), ".");
      };
      return digger.create(digCallback.bind(this));
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
    }
  };

  Game.init();

}).call(this);
