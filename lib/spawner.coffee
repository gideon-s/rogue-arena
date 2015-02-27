class window.Spawner 
  
  constructor: (@game) ->
    if false
      @current = new None(@game)
    else if false
      @current = new One(@game, Citizen)
    else if false
      @current = new Only(@game, MajorDemon)
    else
      @current = new Level1(@game)

  spawn: (rate) ->
    @level().spawn()
    if @game.halt? and @game.halt
      return
    window.setTimeout (=> @spawn(rate)), rate 

  level: () ->
    if @current.finished()
        @current = @current.next()
    @current

class window.Chooser 
    constructor: (@game) ->
    name: () -> this.constructor.name
    create: (type) -> 
        if type?
            new type(@game, @game.map.randomEdgeLocation())
    spawn: () -> @create(@monsterType())
    score: () -> @game.player.score
    next: () -> this

class window.None extends window.Chooser
  constructor: (@game) ->
  finished: () -> false
  spawn: () ->

class window.One extends window.Chooser # for testing purposes
    constructor: (@game, @type) ->
    finished: () -> false
    spawn:() ->
        if @called? 
            return 
        @create @type
        @called = true

class window.Only extends window.Chooser # for testing purposes
    constructor: (@game, @type) ->
    finished: () -> false
    spawn:() -> @create @type

class window.Level1 extends window.Chooser
  monsterType: () -> 
    if Util.oneIn(3) 
      Citizen 
    else if Util.oneIn(3) 
      Firebat
    else 
      MinorDemon
  finished: () -> @score() > 20
  next: () -> new Level2(@game)

class window.Level2 extends window.Chooser
  monsterType: () ->
    if Util.oneIn(2)
      MinorDemon
    else if Util.oneIn(3)
      Citizen
    else if Util.oneIn(3)
      PufferDemon
    else
      OrcCharger
  finished: () -> @score() > 50
  next: () -> new Level3(@game)

class window.Level3 extends window.Chooser
  monsterType: () ->
    if Util.oneIn(3)
      Firebat
    else if Util.oneIn(4)
      Gridbug
    else if Util.oneIn(5)
      Citizen
    else if Util.oneIn(3)
      MajorDemon
    else if Util.oneIn(3)
      PufferDemon
    else
      MinorDemon
  finished: () -> @score() > 100
  next: () -> new Level4(@game)

class window.Level4 extends window.Chooser
    spawn: () ->
        if not @called?
            @called = 0
        @called = @called + 1
        if @called == 20
            for dir in [0..15]
                @create(Gridbug)
            @create(GridBoss)
            @bossSpawned = 1
    finished: () ->
        @bossSpawned? and not _.find(@game.actors, (actor) => actor instanceof GridBoss)
    next: () -> new Level5(@game)

class window.Level5 extends window.Chooser
    monsterType: () ->
        if Util.oneIn(3)
            ElvenArcher
        else if Util.oneIn(5)
            Citizen
    finished: () -> @score() > 400
    next: () -> new Level6(@game)

class window.Level6 extends window.Chooser
    spawn: () ->
        if not @called?
            @called = 0
        @called = @called + 1
        if @called == 2
            for dir in [0..30]
                @create(OrcCharger)
            @create(OrcBoss)
            @bossSpawned = 1
    finished: () ->
        @bossSpawned? and not _.find(@game.actors, (actor) => actor instanceof OrcBoss)
    next: () -> new Level7(@game)

class window.Level7 extends window.Chooser
    spawn: () ->
      if Util.oneIn(3)
        @create MajorDemon
      if Util.oneIn(3)
        @create PufferDemon
      if Util.oneIn(3)
        @create MinorDemon
    finished: () ->
      @score() > 1000
    next: () -> new Level8(@game)

class window.Level8 extends window.Chooser
    spawn: () ->
    finished: () -> false
    

