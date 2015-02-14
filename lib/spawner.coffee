class window.Spawner 
  
  constructor: (@game) ->
    @current = new One(@game, Firebat)
    #@current = new Level1(@game)

  spawn: () ->
    @level().spawn()
    window.setTimeout (=> @spawn()), 1000 

  level: () ->
    if @current.finished()
        @current = @current.next()
    @current

class window.Chooser 
    constructor: (@game) ->
    name: () -> this.constructor.name
    create: (type) -> 
        if type?
            @game.actors.push new type(@game, @game.map.randomEdgeLocation())
    spawn: () -> @create(@monsterType())
    score: () -> @game.player.score
    next: () -> this

class window.One extends window.Chooser # for testing purposes
    constructor: (@game, @type) ->
    finished: () -> false
    spawn:() ->
        if @called? 
            return 
        @create @type
        @called = true

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
    next: () -> new Level6(@game)

    

