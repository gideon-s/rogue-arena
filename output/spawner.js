// Generated by CoffeeScript 1.8.0
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Spawner = (function() {
    function Spawner(game) {
      this.game = game;
      if (false) {
        this.current = new None(this.game);
      } else if (false) {
        this.current = new One(this.game, Citizen);
      } else if (false) {
        this.current = new Only(this.game, MajorDemon);
      } else {
        this.current = new Level1(this.game);
      }
    }

    Spawner.prototype.spawn = function(rate) {
      this.level().spawn();
      if ((this.game.halt != null) && this.game.halt) {
        return;
      }
      return window.setTimeout(((function(_this) {
        return function() {
          return _this.spawn(rate);
        };
      })(this)), rate);
    };

    Spawner.prototype.level = function() {
      if (this.current.finished()) {
        this.current = this.current.next();
      }
      return this.current;
    };

    return Spawner;

  })();

  window.Chooser = (function() {
    function Chooser(game) {
      this.game = game;
    }

    Chooser.prototype.name = function() {
      return this.constructor.name;
    };

    Chooser.prototype.create = function(type) {
      if (type != null) {
        return new type(this.game, this.game.map.randomEdgeLocation());
      }
    };

    Chooser.prototype.spawn = function() {
      return this.create(this.monsterType());
    };

    Chooser.prototype.score = function() {
      return this.game.player.score;
    };

    Chooser.prototype.next = function() {
      return this;
    };

    Chooser.prototype.texts = function() {
      return ["There is nothing written on this page."];
    };

    Chooser.prototype.text = function() {
      return Util.pickRandom(this.texts());
    };

    return Chooser;

  })();

  window.None = (function(_super) {
    __extends(None, _super);

    function None(game) {
      this.game = game;
    }

    None.prototype.finished = function() {
      return false;
    };

    None.prototype.spawn = function() {};

    return None;

  })(window.Chooser);

  window.One = (function(_super) {
    __extends(One, _super);

    function One(game, type) {
      this.game = game;
      this.type = type;
    }

    One.prototype.finished = function() {
      return false;
    };

    One.prototype.spawn = function() {
      if (this.called != null) {
        return;
      }
      this.create(this.type);
      return this.called = true;
    };

    return One;

  })(window.Chooser);

  window.Only = (function(_super) {
    __extends(Only, _super);

    function Only(game, type) {
      this.game = game;
      this.type = type;
    }

    Only.prototype.finished = function() {
      return false;
    };

    Only.prototype.spawn = function() {
      return this.create(this.type);
    };

    return Only;

  })(window.Chooser);

  window.Level1 = (function(_super) {
    __extends(Level1, _super);

    function Level1() {
      return Level1.__super__.constructor.apply(this, arguments);
    }

    Level1.prototype.monsterType = function() {
      if (Util.oneIn(3)) {
        return Citizen;
      } else if (Util.oneIn(3)) {
        return Firebat;
      } else {
        return MinorDemon;
      }
    };

    Level1.prototype.finished = function() {
      return this.score() > 20;
    };

    Level1.prototype.next = function() {
      return new Level2(this.game);
    };

    Level1.prototype.texts = function() {
      return ["I have to rescue these citizens! When I touch them, they disappear - I hope they are going to a better place!", "The demons stalk me slowly but methodically; they grow closer all the time.", "The sulphur given off by these Fire Bats is obnoxious! Thankfully, they generally mind their own business.", "Is there any escape from this hellish place?", "I live; I die; I live again. Am I in a time loop? Am I dead? Will the people I've saved be there to greet me when I stop?", "Maybe I should take a break and let my hands uncramp...", "That citizen gave me a funny look right before he vanished - I hope I'm doing the right thing!", "Who put me here? And why?", "Maybe I should try using a different weapon? Heck, maybe I should try using a few at once!", "The edges of this arena are notoriously dangerous - I should stay near the center!"];
    };

    return Level1;

  })(window.Chooser);

  window.Level2 = (function(_super) {
    __extends(Level2, _super);

    function Level2() {
      return Level2.__super__.constructor.apply(this, arguments);
    }

    Level2.prototype.monsterType = function() {
      if (Util.oneIn(2)) {
        return MinorDemon;
      } else if (Util.oneIn(3)) {
        return Citizen;
      } else if (Util.oneIn(3)) {
        return PufferDemon;
      } else {
        return OrcCharger;
      }
    };

    Level2.prototype.finished = function() {
      return this.score() > 50;
    };

    Level2.prototype.next = function() {
      return new Level3(this.game);
    };

    Level2.prototype.texts = function() {
      return ["What is this I don't even", "Those orcs in the distance look harmless. Maybe we can be friends!", "The markings on that Demon look a little different. And it smells a bit like the Fire Bats!", "Best keep on running and hoping I don't run out of luck!", "If only I could move faster!", "Sometimes I can feel the walls closing in; what mad gods keep putting me here?", "WASD FOR LIFE! ijkl for fun.", "U can change weapons if you want!", "Albert and Wrenja were here.", "Longshot was here."];
    };

    return Level2;

  })(window.Chooser);

  window.Level3 = (function(_super) {
    __extends(Level3, _super);

    function Level3() {
      return Level3.__super__.constructor.apply(this, arguments);
    }

    Level3.prototype.monsterType = function() {
      if (Util.oneIn(3)) {
        return Firebat;
      } else if (Util.oneIn(4)) {
        return Gridbug;
      } else if (Util.oneIn(5)) {
        return Citizen;
      } else if (Util.oneIn(3)) {
        return MajorDemon;
      } else if (Util.oneIn(3)) {
        return PufferDemon;
      } else {
        return MinorDemon;
      }
    };

    Level3.prototype.finished = function() {
      return this.score() > 100;
    };

    Level3.prototype.next = function() {
      return new Level4(this.game);
    };

    Level3.prototype.texts = function() {
      return ["Damn those gridbugs are fast!", "gridbugs are the worst :p", "*sigh* now the demons spew poison and run like hell. I suppose it only gets worse from here?", "DODGE THIS.", "Dammit, citizens, why must you dive into danger and run from me? Couldn't you do the opposite!?", "There is no justice in this killing floor. I pile up the bodies and nothing changes.", "I hope I never see a bigger grid bug. These ones are plenty bad enough.", "My FireWall burned that citizen but the gods didn't care. Why are they so capricious?", "Snatch this text from my hand, Grasshopper.", "Shoot, I shouldn't have stopped to read this scroll.", "This page almost unintentionally left almost blank."];
    };

    return Level3;

  })(window.Chooser);

  window.Level4 = (function(_super) {
    __extends(Level4, _super);

    function Level4() {
      return Level4.__super__.constructor.apply(this, arguments);
    }

    Level4.prototype.spawn = function() {
      var dir, _i;
      if (this.called == null) {
        this.called = 0;
      }
      this.called = this.called + 1;
      if (this.called === 20) {
        for (dir = _i = 0; _i <= 15; dir = ++_i) {
          this.create(Gridbug);
        }
        this.create(GridBoss);
        return this.bossSpawned = 1;
      }
    };

    Level4.prototype.finished = function() {
      return (this.bossSpawned != null) && !_.find(this.game.actors, (function(_this) {
        return function(actor) {
          return actor instanceof GridBoss;
        };
      })(this));
    };

    Level4.prototype.next = function() {
      return new Level5(this.game);
    };

    Level4.prototype.texts = function() {
      return ["AAAAGGH GIANT F***ING GRID BUG!", "SO MANY GRID BUGS!", "What is this life worth when I am surrounded by grid bugs?", "Whew, it finally slowed down - nothing seems to be arriving now...", "Have I reached the end of the line?", "Thank goodness for this MagicMissile. I don't know what I would do without it!"];
    };

    return Level4;

  })(window.Chooser);

  window.Level5 = (function(_super) {
    __extends(Level5, _super);

    function Level5() {
      return Level5.__super__.constructor.apply(this, arguments);
    }

    Level5.prototype.monsterType = function() {
      if (Util.oneIn(3)) {
        return ElvenArcher;
      } else if (Util.oneIn(5)) {
        return Citizen;
      }
    };

    Level5.prototype.finished = function() {
      return this.score() > 400;
    };

    Level5.prototype.next = function() {
      return new Level6(this.game);
    };

    Level5.prototype.texts = function() {
      return ["These Elven Archers' aim is terrible!", "Why don't the archers die like I do when I shoot a citizen!? Those capricious gods agin.", "Now the archers are closing in!", "Thank goodness for this MagicMissile. I don't know what I would do without it!", "Suck FireBall, evil doer!", "I'm afraid if the archers hit me I will be having an existential crisis :(", "Am I halfway through this trial? Will I ever be through?"];
    };

    return Level5;

  })(window.Chooser);

  window.Level6 = (function(_super) {
    __extends(Level6, _super);

    function Level6() {
      return Level6.__super__.constructor.apply(this, arguments);
    }

    Level6.prototype.spawn = function() {
      var dir, _i;
      if (this.called == null) {
        this.called = 0;
      }
      this.called = this.called + 1;
      if (this.called === 2) {
        for (dir = _i = 0; _i <= 30; dir = ++_i) {
          this.create(OrcCharger);
        }
        this.create(OrcBoss);
        return this.bossSpawned = 1;
      }
    };

    Level6.prototype.finished = function() {
      return (this.bossSpawned != null) && !_.find(this.game.actors, (function(_this) {
        return function(actor) {
          return actor instanceof OrcBoss;
        };
      })(this));
    };

    Level6.prototype.next = function() {
      return new Level7(this.game);
    };

    return Level6;

  })(window.Chooser);

  window.Level7 = (function(_super) {
    __extends(Level7, _super);

    function Level7() {
      return Level7.__super__.constructor.apply(this, arguments);
    }

    Level7.prototype.spawn = function() {
      if (Util.oneIn(3)) {
        this.create(MajorDemon);
      }
      if (Util.oneIn(3)) {
        this.create(PufferDemon);
      }
      if (Util.oneIn(3)) {
        return this.create(MinorDemon);
      }
    };

    Level7.prototype.finished = function() {
      return this.score() > 1000;
    };

    Level7.prototype.next = function() {
      return new Level8(this.game);
    };

    return Level7;

  })(window.Chooser);

  window.Level8 = (function(_super) {
    __extends(Level8, _super);

    function Level8() {
      return Level8.__super__.constructor.apply(this, arguments);
    }

    Level8.prototype.spawn = function() {};

    Level8.prototype.finished = function() {
      return false;
    };

    return Level8;

  })(window.Chooser);

}).call(this);
