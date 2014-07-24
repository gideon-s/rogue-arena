// Generated by CoffeeScript 1.7.1
(function() {
  var Player, dragon;

  window.Game = {
    display: null,
    oldMap: {},
    map: new Map(),
    engine: null,
    player: null,
    dragon: null,
    ananas: null,
    init: function() {
      var scheduler;
      this.display = new ROT.Display({
        spacing: 1.1
      });
      document.body.appendChild(this.display.getContainer());
      this._generateMap();
      scheduler = new ROT.Scheduler.Simple();
      scheduler.add(this.player, true);
      scheduler.add(this.dragon, true);
      this.engine = new ROT.Engine(scheduler);
      return this.engine.start();
    },
    _generateMap: function() {
      var digCallback, digger, freeCells;
      digger = new ROT.Map.Digger();
      freeCells = [];
      digCallback = function(x, y, value) {
        var key;
        if (value) {
          return;
        }
        this.map.setSquare([x, y], ".");
        key = Coordinates.create(x, y);
        this.oldMap[key] = ".";
        return freeCells.push(key);
      };
      digger.create(digCallback.bind(this));
      this._generateBoxes(freeCells);
      this._drawWholeMap();
      this.player = this._createBeing(Player, freeCells);
      return this.dragon = this._createBeing(dragon, freeCells);
    },
    _createBeing: function(what, freeCells) {
      var x, y, _ref;
      _ref = Coordinates.selectRandom(freeCells), x = _ref[0], y = _ref[1];
      return new what(x, y);
    },
    _generateBoxes: function(freeCells) {
      var i, key, _results;
      i = 0;
      _results = [];
      while (i < 10) {
        key = Util.pickRandom(freeCells);
        this.map.setSquare(Coordinates.parse(key), "*");
        this.oldMap[key] = "*";
        if (!i) {
          this.ananas = key;
        }
        _results.push(i++);
      }
      return _results;
    },
    _drawWholeMap: function() {
      var key, x, y, _ref, _results;
      _results = [];
      for (key in this.oldMap) {
        _ref = Coordinates.parse(key), x = _ref[0], y = _ref[1];
        _results.push(this.display.draw(x, y, this.oldMap[key]));
      }
      return _results;
    }
  };

  Player = function(x, y) {
    this._x = x;
    this._y = y;
    return this._draw();
  };

  Player.prototype.getSpeed = function() {
    return 100;
  };

  Player.prototype.getX = function() {
    return this._x;
  };

  Player.prototype.getY = function() {
    return this._y;
  };

  Player.prototype.act = function() {
    Game.engine.lock();
    return window.addEventListener("keydown", this);
  };

  Player.prototype.handleEvent = function(e) {
    var code, dir, keyMap, newKey, newX, newY;
    code = e.keyCode;
    if (code === 13 || code === 32) {
      this._checkBox();
      return;
    }
    keyMap = {};
    keyMap[38] = 0;
    keyMap[33] = 1;
    keyMap[39] = 2;
    keyMap[34] = 3;
    keyMap[40] = 4;
    keyMap[35] = 5;
    keyMap[37] = 6;
    keyMap[36] = 7;
    if (!(code in keyMap)) {
      return;
    }
    dir = ROT.DIRS[8][keyMap[code]];
    newX = this._x + dir[0];
    newY = this._y + dir[1];
    newKey = Coordinates.create(newX, newY);
    if (!(newKey in Game.oldMap)) {
      return;
    }
    Game.display.draw(this._x, this._y, Game.oldMap[Coordinates.create(this._x, this._y)]);
    this._x = newX;
    this._y = newY;
    this._draw();
    window.removeEventListener("keydown", this);
    return Game.engine.unlock();
  };

  Player.prototype._draw = function() {
    return Game.display.draw(this._x, this._y, "@", "#ff0");
  };

  Player.prototype._checkBox = function() {
    var key;
    key = Coordinates.create(this._x, this._y);
    if (Game.oldMap[key] !== "*") {
      return console.log("There is no box here!");
    } else if (key === Game.ananas) {
      console.log("Hooray! You found the gem of success and won this game.");
      Game.engine.lock();
      return window.removeEventListener("keydown", this);
    } else {
      return console.log("This box is empty :-(");
    }
  };

  dragon = function(x, y) {
    this._x = x;
    this._y = y;
    return this._draw();
  };

  dragon.prototype.getSpeed = function() {
    return 100;
  };

  dragon.prototype.act = function() {
    var astar, passableCallback, path, pathCallback, x, y;
    x = Game.player.getX();
    y = Game.player.getY();
    passableCallback = function(x, y) {
      return x + "," + y in Game.oldMap;
    };
    astar = new ROT.Path.AStar(x, y, passableCallback, {
      topology: 4
    });
    path = [];
    pathCallback = function(x, y) {
      return path.push([x, y]);
    };
    astar.compute(this._x, this._y, pathCallback);
    path.shift();
    console.log("path length is " + path.length);
    if (path.length < 2) {
      Game.engine.lock();
      return alert("Game over - you were eaten by the dragon!");
    } else {
      x = path[0][0];
      y = path[0][1];
      Game.display.draw(this._x, this._y, Game.oldMap[Coordinates.create(this._x, this._y)]);
      this._x = x;
      this._y = y;
      return this._draw();
    }
  };

  dragon.prototype._draw = function() {
    return Game.display.draw(this._x, this._y, "&", "red");
  };

  Game.init();

}).call(this);
