class window.Spawner 
  
  constructor: (@game) ->
    @current = new Level1(@game)

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
    create: (type) -> @game.actors.push new type(@game, @game.map.randomEdgeLocation())
    spawn: () -> @create(@monsterType())
    score: () -> @game.player.score

class window.Level1 extends window.Chooser
  monsterType: () -> MinorDemon
  finished: () -> @score() > 10
  next: () -> new Level2(@game)

class window.Level2 extends window.Chooser
  monsterType: () ->
    if Util.oneIn(2)
      type = MinorDemon
    else
      type = Gridbug
  finished: () -> @score() > 20
  next: () -> new Level3(@game)

class window.Level3 extends window.Chooser
  monsterType: () ->
    if Util.oneIn(10)
      type = ElvenArcher
    else if Util.oneIn(3)
      type = Gridbug
    else 
      type = MinorDemon
  finished: () -> @score() > 30
  next: () -> new Level4(@game)

class window.Level4 extends window.Chooser
    spawn: () ->
        if not @called?
            @called = 0
        @called = @called + 1
        if @called == 10
            for dir in [0..30]
                @create(Gridbug)
            @create(Boss1)
    finished: () ->
        @called > 10 and not _.find(@game.actors, (actor) => actor instanceof Boss1)
    next: () -> new Level5(@game)

class window.Level5 extends window.Chooser
    monsterType: () ->
        ElvenArcher
    finished: () -> false
    next: () -> new Level5(@game)

    

