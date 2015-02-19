// Generated by CoffeeScript 1.7.1
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  window.Player = (function(_super) {
    __extends(Player, _super);

    function Player(game, location) {
      Player.__super__.constructor.call(this, game, location, "@", "white", 100);
      this.lastCode = {};
      this.allowedWeapons = [window.Dart, window.RescueRay, window.ControlledBlink, window.FireBall, window.FireWall, window.SmokeTrail, window.MagicMissile, window.KnifeWall];
      this.weapons = {};
      this.modKeys = ['shiftKey', 'altKey', 'ctrlKey', 'metaKey'];
      this.changeWeapon();
      this.score = 0;
      this.shotsFired = 0;
      window.addEventListener("keydown", this);
      window.addEventListener("keyup", this);
    }

    Player.prototype.struckBy = function(entity) {
      if (entity instanceof Citizen) {
        return entity.struckBy(this);
      } else {
        return Player.__super__.struckBy.call(this, entity);
      }
    };

    Player.prototype.handleModifier = function(e, mod) {
      if (e[mod]) {
        return this.lastCode[mod] = 1;
      } else {
        return this.lastCode[mod] = 0;
      }
    };

    Player.prototype.handleEvent = function(e) {
      this.handleModifier(e, 'shiftKey');
      this.handleModifier(e, 'ctrlKey');
      this.handleModifier(e, 'altKey');
      this.handleModifier(e, 'metaKey');
      if (e.type === "keydown") {
        if (e.keyCode === ROT.VK_U) {
          return this.changeWeapon();
        } else {
          return this.lastCode[e.keyCode] = 1;
        }
      } else if (e.type === "keyup") {
        return this.lastCode[e.keyCode] = 0;
      }
    };

    Player.prototype.moveDir = function(dirIndex) {
      var dir, nextLocation;
      dir = ROT.DIRS[8][dirIndex];
      nextLocation = this.location.addDir(dir);
      return this.moveTo(nextLocation);
    };

    Player.prototype.fire = function(dirIndex) {
      var fired;
      fired = false;
      _.each(this.modKeys, (function(_this) {
        return function(mod) {
          var weapon;
          if (_this.keysPressed(mod)) {
            weapon = _this.weapons[mod];
            if (weapon != null) {
              weapon.fire(dirIndex);
              return fired = true;
            }
          }
        };
      })(this));
      if (!fired) {
        return this.weapons['main'].fire(dirIndex);
      }
    };

    Player.prototype.changeWeapon = function() {
      var changed, doChange;
      changed = false;
      doChange = (function(_this) {
        return function(mod) {
          var type;
          type = Util.rotate(_this.allowedWeapons);
          _this.weapons[mod] = new type(_this);
          _this.game.drawScore();
          return changed = true;
        };
      })(this);
      _.each(this.modKeys, (function(_this) {
        return function(mod) {
          if (_this.keysPressed(mod)) {
            return doChange(mod);
          }
        };
      })(this));
      if (!changed) {
        return doChange('main');
      }
    };

    Player.prototype.addScore = function(amount) {
      if (amount == null) {
        amount = 1;
      }
      if (!this.dead) {
        this.score += amount;
      }
      return this.game.drawScore();
    };

    Player.prototype.keysPressed = function() {
      var keys;
      keys = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return _.every(keys, (function(_this) {
        return function(k) {
          return _this.lastCode[k] === 1;
        };
      })(this));
    };

    Player.prototype.clearKeys = function() {
      var keys;
      keys = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return _.each(keys, (function(_this) {
        return function(k) {
          return _this.lastCode[k] = 0;
        };
      })(this));
    };

    Player.prototype.wasdDirection = function(w, a, s, d) {
      var direction;
      if (this.keysPressed(w, d)) {
        return direction = 1;
      } else if (this.keysPressed(d, s)) {
        return direction = 3;
      } else if (this.keysPressed(s, a)) {
        return direction = 5;
      } else if (this.keysPressed(a, w)) {
        return direction = 7;
      } else if (this.keysPressed(w)) {
        return direction = 0;
      } else if (this.keysPressed(d)) {
        return direction = 2;
      } else if (this.keysPressed(s)) {
        return direction = 4;
      } else if (this.keysPressed(a)) {
        return direction = 6;
      }
    };

    Player.prototype.act = function(e) {
      var fireDirection, moveDirection;
      if (this.lastCode == null) {
        return;
      }
      moveDirection = this.wasdDirection(ROT.VK_W, ROT.VK_A, ROT.VK_S, ROT.VK_D);
      fireDirection = this.wasdDirection(ROT.VK_I, ROT.VK_J, ROT.VK_K, ROT.VK_L);
      if (moveDirection != null) {
        this.moveDir(moveDirection);
      }
      if (fireDirection != null) {
        this.fire(fireDirection);
      }
      if (this.keysPressed(ROT.VK_P)) {
        this.addScore(10);
        return this.game.spawner.current = this.game.spawner.current.next();
      }
    };

    return Player;

  })(window.Actor);

}).call(this);
