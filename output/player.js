// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Player = (function(_super) {
    __extends(Player, _super);

    function Player(location) {
      Player.__super__.constructor.call(this, Game, location, "@", "white", 50);
      this.score = 0;
      this.shotsFired = 0;
      window.addEventListener("keydown", this);
    }

    Player.prototype.getLocation = function() {
      return this.location;
    };

    Player.prototype.handleEvent = function(e) {
      return this.lastCode = e.keyCode;
    };

    Player.prototype.moveDir = function(dirIndex) {
      var dir, nextLocation;
      dir = ROT.DIRS[8][dirIndex];
      nextLocation = this.location.addDir(dir);
      if (!Game.map.isOpen(nextLocation)) {
        return;
      }
      return this.location = nextLocation;
    };

    Player.prototype.fire = function(dirIndex) {
      var dir, nextLocation;
      dir = ROT.DIRS[8][dirIndex];
      nextLocation = this.location.addDir(dir);
      new Projectile(nextLocation, dir);
      return this.shotsFired++;
    };

    Player.prototype.addScore = function() {
      return this.score++;
    };

    Player.prototype.act = function(e) {
      var keyMap;
      keyMap = {};
      keyMap[13] = keyMap[32] = (function(_this) {
        return function() {
          return _this.checkBox();
        };
      })(this);
      keyMap[87] = (function(_this) {
        return function() {
          return _this.moveDir(0);
        };
      })(this);
      keyMap[69] = (function(_this) {
        return function() {
          return _this.moveDir(1);
        };
      })(this);
      keyMap[68] = (function(_this) {
        return function() {
          return _this.moveDir(2);
        };
      })(this);
      keyMap[67] = (function(_this) {
        return function() {
          return _this.moveDir(3);
        };
      })(this);
      keyMap[88] = (function(_this) {
        return function() {
          return _this.moveDir(4);
        };
      })(this);
      keyMap[90] = (function(_this) {
        return function() {
          return _this.moveDir(5);
        };
      })(this);
      keyMap[65] = (function(_this) {
        return function() {
          return _this.moveDir(6);
        };
      })(this);
      keyMap[81] = (function(_this) {
        return function() {
          return _this.moveDir(7);
        };
      })(this);
      keyMap[89] = (function(_this) {
        return function() {
          return _this.fire(0);
        };
      })(this);
      keyMap[85] = (function(_this) {
        return function() {
          return _this.fire(1);
        };
      })(this);
      keyMap[74] = (function(_this) {
        return function() {
          return _this.fire(2);
        };
      })(this);
      keyMap[77] = (function(_this) {
        return function() {
          return _this.fire(3);
        };
      })(this);
      keyMap[78] = (function(_this) {
        return function() {
          return _this.fire(4);
        };
      })(this);
      keyMap[66] = (function(_this) {
        return function() {
          return _this.fire(5);
        };
      })(this);
      keyMap[71] = (function(_this) {
        return function() {
          return _this.fire(6);
        };
      })(this);
      keyMap[84] = (function(_this) {
        return function() {
          return _this.fire(7);
        };
      })(this);
      keyMap[38] = (function(_this) {
        return function() {
          return _this.fire(0);
        };
      })(this);
      keyMap[33] = (function(_this) {
        return function() {
          return _this.fire(1);
        };
      })(this);
      keyMap[39] = (function(_this) {
        return function() {
          return _this.fire(2);
        };
      })(this);
      keyMap[34] = (function(_this) {
        return function() {
          return _this.fire(3);
        };
      })(this);
      keyMap[40] = (function(_this) {
        return function() {
          return _this.fire(4);
        };
      })(this);
      keyMap[35] = (function(_this) {
        return function() {
          return _this.fire(5);
        };
      })(this);
      keyMap[37] = (function(_this) {
        return function() {
          return _this.fire(6);
        };
      })(this);
      keyMap[36] = (function(_this) {
        return function() {
          return _this.fire(7);
        };
      })(this);
      keyMap[27] = (function(_this) {
        return function() {
          return location.reload();
        };
      })(this);
      if ((this.lastCode != null) && (this.lastCode in keyMap)) {
        keyMap[this.lastCode]();
      }
      return this.lastCode = null;
    };

    Player.prototype.checkBox = function() {
      if (Game.map.at(this.location) !== "*") {
        return alert("There is no box here!");
      } else if (_.isEqual(this.location, Game.prize)) {
        alert("Hooray! You found the gem of success and won this game.");
        window.removeEventListener("keydown", this);
        return location.reload();
      } else {
        return alert("This box is empty :-(");
      }
    };

    return Player;

  })(window.Actor);

}).call(this);
