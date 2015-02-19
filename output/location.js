// Generated by CoffeeScript 1.7.1
(function() {
  var __slice = [].slice;

  window.Location = (function() {
    function Location(game, map, pair) {
      this.game = game;
      this.map = map;
      if (!this.game instanceof Game) {
        throw new Error("game not set to instance of Game");
      }
      if (pair.length !== 2) {
        throw new Error("error in pair length: " + pair);
      }
      if (typeof pair[0] !== "number") {
        throw new Error("First in pair is not a number: " + pair[0]);
      }
      if (typeof pair[1] !== "number") {
        throw new Error("Second in pair is not a number: " + pair[1]);
      }
      this.x = pair[0];
      this.y = pair[1];
    }

    Location.prototype.isOpen = function() {
      return true;
    };

    Location.prototype.pair = function() {
      return [this.x, this.y];
    };

    Location.prototype.subtractDir = function(dir, amount) {
      if (amount == null) {
        amount = 1;
      }
      return this.addDir(dir, amount * -1);
    };

    Location.prototype.addDir = function(dir, amount) {
      if (amount == null) {
        amount = 1;
      }
      return this.map.lookupLocation([this.x + (amount * dir[0]), this.y + (amount * dir[1])]);
    };

    Location.prototype.pathToDestination = function(destination, map, topology) {
      var astar, dest, passableCallback, path, pathCallback;
      if (topology == null) {
        topology = 8;
      }
      passableCallback = (function(_this) {
        return function(x, y) {
          return map.isOpen(_this.map.lookupLocation([x, y]));
        };
      })(this);
      dest = destination.pair();
      astar = new ROT.Path.AStar(dest[0], dest[1], passableCallback, {
        topology: topology
      });
      path = [];
      pathCallback = (function(_this) {
        return function(x, y) {
          return path.push(_this.map.lookupLocation([x, y]));
        };
      })(this);
      astar.compute(this.x, this.y, pathCallback);
      path.shift();
      return path;
    };

    Location.prototype.nextStepToDestination = function(destination, map, topology) {
      if (topology == null) {
        topology = 8;
      }
      return this.pathToDestination(destination, map, topology)[0];
    };

    Location.prototype.drawOn = function(display, character, color) {
      return display.draw(this.x, this.y + 1, character, color);
    };

    Location.prototype.otherActors = function(entity) {
      return _.filter(this.game.actors, (function(_this) {
        return function(actor) {
          return (actor !== entity) && (_.isEqual(actor.location, _this));
        };
      })(this));
    };

    Location.prototype.hasOtherActor = function(theActor, other) {
      return _.find(this.otherActors(theActor), (function(_this) {
        return function(actor) {
          return actor === other;
        };
      })(this));
    };

    Location.prototype.hasOtherActorType = function(theActor, type) {
      return _.find(this.otherActors(theActor), (function(_this) {
        return function(actor) {
          return actor instanceof type;
        };
      })(this));
    };

    Location.prototype.toString = function() {
      return "[ " + this.x + ", " + this.y + " ]";
    };

    return Location;

  })();

  window.NoLocation = (function() {
    function NoLocation() {}

    NoLocation.prototype.isOpen = function() {
      return false;
    };

    NoLocation.prototype.hasOtherActor = function() {
      var unused;
      unused = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return false;
    };

    NoLocation.prototype.hasOtherActorType = function() {
      var unused;
      unused = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return false;
    };

    return NoLocation;

  })();

}).call(this);
