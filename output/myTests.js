// Generated by CoffeeScript 1.8.0
(function() {
  var mockGame;

  mockGame = {
    player: false,
    actors: [],
    map: new Map(5, 5),
    drawMapLocation: function(loc) {},
    gameOver: function() {},
    enters: function() {},
    draw: function() {},
    nextAction: function() {}
  };

  test("location constructor does not accept invalid values", function() {
    throws((function() {
      return new Location(mockGame, "X");
    }), "asdf");
    throws((function() {
      return new Location(mockGame, [1, 2, 3]);
    }), "three ints");
    throws((function() {
      return new Location(mockGame, ["one", "two"]);
    }), "two strings");
    return throws((function() {
      return new Location(mockGame, ["X", "Y"]);
    }), "array of char");
  });

  test("map 'on' does not accept an invalid argument", function() {
    var location1, map;
    location1 = new Location(mockGame, [1, 1]);
    map = "This is a string";
    return throws((function() {
      return location1.on(map);
    }), "map is bad");
  });

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

  test("Util.rotate works", function() {
    var f;
    f = [1, 2, 3];
    equal(1, Util.rotate(f));
    deepEqual(f, [2, 3, 1]);
    equal(2, Util.rotate(f));
    deepEqual(f, [3, 1, 2]);
    equal(3, Util.rotate(f));
    return deepEqual(f, [1, 2, 3]);
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

  test("Map 1 and Map 2 should contain different characters at 0,0", function() {
    var location, map1, map2;
    map1 = new Map(mockGame, 3, 3);
    map2 = new Map(mockGame, 3, 3);
    location = new Location(mockGame, [0, 0]);
    map1.setLocation(location, "@");
    equal("@", map1.at(location));
    map2.setLocation(location, "$");
    equal("$", map2.at(location));
    return notEqual(map1.at(location), map2.at(location));
  });

  test("locations of map should return list of x,y pairs", function() {
    var location, location2, map;
    map = new Map(mockGame, 1, 2);
    location = new Location(mockGame, [0, 0]);
    location2 = new Location(mockGame, [0, 1]);
    return deepEqual([location, location2], map.locations());
  });

  test("Is open map area", function() {
    var location, location2, map;
    map = new Map(mockGame, 3, 3);
    location = new Location(mockGame, [0, 1]);
    location2 = new Location(mockGame, [2, 3]);
    ok(map.isOpen(location));
    return ok(!map.isOpen(location2));
  });

  test("map.randomLocation returns realistic value spread", function() {
    var actual, i, location, map, val, _i, _j, _k, _len, _len1, _ref, _ref1;
    map = new Map(mockGame, 1, 10);
    _ref = map.locations();
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      location = _ref[_i];
      map.setLocation(location, "0");
    }
    for (i = _j = 0; _j < 100; i = ++_j) {
      location = map.randomLocation();
      val = map.at(location);
      val++;
      map.setLocation(location, val);
    }
    actual = true;
    _ref1 = map.locations();
    for (_k = 0, _len1 = _ref1.length; _k < _len1; _k++) {
      location = _ref1[_k];
      if (map.at(location) > 18 || map.at(location) < 3) {
        actual = false;
      }
    }
    return equal(actual, true);
  });

  test("location(0,1) returns x=0 and y=1", function() {
    var location;
    location = new Location(mockGame, [0, 1]);
    equal(location.x, 0);
    equal(location.y, 1);
    location = location.addDir([1, 1]);
    equal(location.x, 1);
    return equal(location.y, 2);
  });

  test("path contains expected path to destination, nextStep contains the first location in the path", function() {
    var destLocation, expectedNext, expectedPath, location, map, nextStep, path;
    map = new Map(mockGame, 5, 5);
    location = new Location(mockGame, [2, 1]);
    destLocation = new Location(mockGame, [2, 4]);
    path = location.pathToDestination(destLocation, map);
    nextStep = location.nextStepToDestination(destLocation, map);
    expectedPath = [new Location(mockGame, [2, 2]), new Location(mockGame, [2, 3]), new Location(mockGame, [2, 4])];
    expectedNext = new Location(mockGame, [2, 2]);
    deepEqual(path, expectedPath);
    return deepEqual(nextStep, expectedNext);
  });

  test("actor is not dead", function() {
    var actor, location;
    location = new Location(mockGame, [1, 1]);
    mockGame.map.setLocation(location, " ");
    actor = new Actor(mockGame, location, "Y", "blue", 50);
    return equal(actor.dead, false);
  });

  test("actor struckBy another actor kills both", function() {
    var actor, actor2, location1, location2;
    location1 = new Location(mockGame, [0, 0]);
    location2 = new Location(mockGame, [0, 1]);
    mockGame.map.setLocation(location1, " ");
    mockGame.map.setLocation(location2, " ");
    actor = new Actor(mockGame, location1, "Y", "blue", 50);
    actor2 = new Actor(mockGame, location2, "X", "red", 50);
    equal(actor.dead, false);
    actor.struckBy(actor2);
    equal(actor.dead, true);
    return equal(actor2.dead, true);
  });

  test("edgeLocations contain map edge coordinates", function() {
    var map;
    map = new Map(mockGame, 2, 2);
    return deepEqual(map.edgeLocations(), [new Location(mockGame, [0, 0]), new Location(mockGame, [0, 1]), new Location(mockGame, [1, 0]), new Location(mockGame, [1, 1])]);
  });

  test("In map.on, return false if location is undefined", function() {
    var map;
    map = new Map(mockGame, 3, 2);
    equal(map.isOpen(new Location(mockGame, [-1, -1])), false);
    equal(map.isOpen(new Location(mockGame, [0, 2])), false);
    equal(map.isOpen(new Location(mockGame, [0, -1])), false);
    equal(map.isOpen(new Location(mockGame, [1, 2])), false);
    return equal(map.isOpen(new Location(mockGame, [4, 3])), false);
  });

  window.TestClass = (function() {
    function TestClass(number) {
      this.number = number;
    }

    TestClass.init = function() {
      return this.test = new TestClass(7);
    };

    TestClass.instance = function() {
      return this.test;
    };

    return TestClass;

  })();

  test("Test class factory method works within a class", function() {
    TestClass.init();
    return equal(7, TestClass.instance().number);
  });

  test("removeFromArray removes object from array", function() {
    var resultArray, testArray;
    testArray = ["stuff", "things", "whatnot", "crap", "value"];
    console.log(testArray);
    Util.removeFromArray(testArray, "whatnot");
    console.log(testArray);
    resultArray = ["stuff", "things", "crap", "value"];
    deepEqual(resultArray, testArray);
    Util.removeFromArray(testArray, "stuff");
    resultArray = ["things", "crap", "value"];
    deepEqual(resultArray, testArray);
    Util.removeFromArray(testArray, "value");
    resultArray = ["things", "crap"];
    return deepEqual(resultArray, testArray);
  });

}).call(this);
