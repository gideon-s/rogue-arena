// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Player = (function(_super) {
    __extends(Player, _super);

    function Player(game, location) {
      Player.__super__.constructor.call(this, game, location, "@", "white", 50);
      this.score = 0;
      this.shotsFired = 0;
      window.addEventListener("keydown", this);
    }

    Player.prototype.handleEvent = function(e) {
      return this.lastCode = e.keyCode;
    };

    Player.prototype.moveDir = function(dirIndex) {
      var dir, nextLocation;
      dir = ROT.DIRS[8][dirIndex];
      nextLocation = this.location.addDir(dir);
      if (!this.game.map.isOpen(nextLocation)) {
        return;
      }
      return this.location = nextLocation;
    };

    Player.prototype.fire = function(dirIndex) {
      var dir, nextLocation;
      dir = ROT.DIRS[8][dirIndex];
      nextLocation = this.location.addDir(dir);
      new Projectile(this.game, nextLocation, dir);
      return this.shotsFired++;
    };

    Player.prototype.addScore = function() {
      this.score++;
      return this.game.drawScore();
    };

    Player.prototype.act = function(e) {
      var keyMap;
      keyMap = {};
      keyMap[ROT.VK_W] = (function(_this) {
        return function() {
          return _this.moveDir(0);
        };
      })(this);
      keyMap[ROT.VK_D] = (function(_this) {
        return function() {
          return _this.moveDir(2);
        };
      })(this);
      keyMap[ROT.VK_S] = (function(_this) {
        return function() {
          return _this.moveDir(4);
        };
      })(this);
      keyMap[ROT.VK_A] = (function(_this) {
        return function() {
          return _this.moveDir(6);
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

    return Player;

  })(window.Actor);

}).call(this);
