// Generated by CoffeeScript 1.7.1
(function() {
  test("Random Returns number between 0 and 9", function() {
    var actual, index, number, _i, _results;
    _results = [];
    for (index = _i = 1; _i <= 200; index = ++_i) {
      number = Util.rand(10);
      actual = number <= 10 && number >= 0 ? true : false;
      _results.push(equal(actual, true));
    }
    return _results;
  });

  test("Random Returns integer", function() {
    var actual, index, number, _i, _results;
    _results = [];
    for (index = _i = 1; _i <= 100; index = ++_i) {
      number = Util.rand(50);
      actual = parseFloat(number) === parseInt(number) ? true : false;
      _results.push(equal(actual, true));
    }
    return _results;
  });

  test("pickRandom Returns items from list", function() {
    var index, listOfThings, result, t, thing, _i, _j, _len, _results;
    listOfThings = ['head', 'right arm', 'left arm', 'chest', 'groin', 'right leg', 'left leg'];
    result = {};
    for (index = _i = 1; _i <= 100; index = ++_i) {
      thing = Util.pickRandom(listOfThings);
      result[thing] || (result[thing] = 0);
      result[thing] += 1;
    }
    _results = [];
    for (_j = 0, _len = listOfThings.length; _j < _len; _j++) {
      t = listOfThings[_j];
      _results.push(ok(result[t], "failed to find " + t));
    }
    return _results;
  });

  test("Coordinate Parse returns x=10 y=20", function() {
    var actual, key, x, y, _ref;
    key = '10,20';
    _ref = Coordinates.parse(key), x = _ref[0], y = _ref[1];
    actual = x === 10 && y === 20 ? true : false;
    return equal(actual, true);
  });

  test("Coordinate Create returns 10,20", function() {
    var actual, keyVal, x, y;
    x = 10;
    y = 20;
    keyVal = Coordinates.create(x, y);
    actual = keyVal === "10,20" ? true : false;
    return equal(actual, true);
  });

  test("Coordinate selectRandom returns values from list of coordinates", function() {
    var c, coordList, coords, index, result, x, y, _i, _j, _len, _ref, _results;
    coordList = ["1,1", "1,2", "1,3", "1,4", "1,5", "1,6", "1,7", "1,8", "1,9", "1,10", "2,1", "2,2", "2,3", "2,4", "2,5", "2,6", "2,7", "2,8", "2,9", "2,10"];
    result = {};
    for (index = _i = 1; _i <= 200; index = ++_i) {
      _ref = Coordinates.selectRandom(coordList), x = _ref[0], y = _ref[1];
      coords = Coordinates.create(x, y);
      result[coords] || (result[coords] = 0);
      result[coords] += 1;
    }
    _results = [];
    for (_j = 0, _len = coordList.length; _j < _len; _j++) {
      c = coordList[_j];
      _results.push(ok(result[c], "failed to find " + c));
    }
    return _results;
  });

  test("Map 1 and Map 2 should contain different characters at 0,0", function() {
    var map1, map2;
    map1 = new Map();
    map2 = new Map();
    map1.setSquare([0, 0], "@");
    map2.setSquare([0, 0], "$");
    return notEqual(map1.at([0, 0]), map2.at([0, 0]));
  });

}).call(this);