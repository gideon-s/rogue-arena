// Generated by CoffeeScript 1.7.1
(function() {
  window.Player = (function() {
    function Player(location) {
      this.location = location;
      this.draw();
    }

    Player.prototype.getSpeed = function() {
      return 100;
    };

    Player.prototype.getLocation = function() {
      return this.location;
    };

    Player.prototype.act = function() {
      Game.engine.lock();
      return window.addEventListener("keydown", this);
    };

    Player.prototype.moveDir = function(dirIndex) {
      var dir, nextLocation;
      dir = ROT.DIRS[8][dirIndex];
      nextLocation = Location.addDir(this.location, dir);
      if (!Game.map.isOpen(nextLocation)) {
        return;
      }
      Game.drawMapLocation(this.location);
      this.location = nextLocation;
      return this.draw();
    };

    Player.prototype.handleEvent = function(e) {
      var code, keyMap;
      keyMap = {};
      keyMap[13] = keyMap[32] = (function(_this) {
        return function() {
          return _this.checkBox();
        };
      })(this);
      keyMap[38] = (function(_this) {
        return function() {
          return _this.moveDir(0);
        };
      })(this);
      keyMap[33] = (function(_this) {
        return function() {
          return _this.moveDir(1);
        };
      })(this);
      keyMap[39] = (function(_this) {
        return function() {
          return _this.moveDir(2);
        };
      })(this);
      keyMap[34] = (function(_this) {
        return function() {
          return _this.moveDir(3);
        };
      })(this);
      keyMap[40] = (function(_this) {
        return function() {
          return _this.moveDir(4);
        };
      })(this);
      keyMap[35] = (function(_this) {
        return function() {
          return _this.moveDir(5);
        };
      })(this);
      keyMap[37] = (function(_this) {
        return function() {
          return _this.moveDir(6);
        };
      })(this);
      keyMap[36] = (function(_this) {
        return function() {
          return _this.moveDir(7);
        };
      })(this);
      code = e.keyCode;
      if (!(code in keyMap)) {
        return;
      }
      keyMap[code]();
      window.removeEventListener("keydown", this);
      return Game.engine.unlock();
    };

    Player.prototype.draw = function() {
      return Game.draw(this.location, "@", "#ff0");
    };

    Player.prototype.checkBox = function() {
      if (Game.map.at(this.location) !== "*") {
        return alert("There is no box here!");
      } else if (this.location === Game.ananas) {
        alert("Hooray! You found the gem of success and won this game.");
        Game.engine.lock();
        return window.removeEventListener("keydown", this);
      } else {
        return alert("This box is empty :-(");
      }
    };

    return Player;

  })();

}).call(this);
