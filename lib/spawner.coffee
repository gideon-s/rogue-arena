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
    texts: () -> ["There is nothing written on this page."]
    text: () -> Util.pickRandom(@texts())

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
  texts: () -> [
      "I have to rescue these citizens! When I touch them, they disappear - I hope they are going to a better place!",
      "The demons stalk me slowly but methodically; they grow closer all the time.",
      "The sulphur given off by these Fire Bats is obnoxious! Thankfully, they generally mind their own business.",
      "Is there any escape from this hellish place?",
      "I live; I die; I live again. Am I in a time loop? Am I dead? Will the people I've saved be there to greet me when I stop?",
      "Maybe I should take a break and let my hands uncramp...", 
      "That citizen gave me a funny look right before he vanished - I hope I'm doing the right thing!",
      "Who put me here? And why?",
      "Maybe I should try using a different weapon? Heck, maybe I should try using a few at once!",
      "The edges of this arena are notoriously dangerous - I should stay near the center!"
    ]

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
  texts: () -> [
      "What is this I don't even",
      "Those orcs in the distance look harmless. Maybe we can be friends!",
      "The markings on that Demon look a little different. And it smells a bit like the Fire Bats!",
      "Best keep on running and hoping I don't run out of luck!",
      "If only I could move faster!",
      "Sometimes I can feel the walls closing in; what mad gods keep putting me here?",
      "WASD FOR LIFE! ijkl for fun.",
      "U can change weapons if you want!",
      "Albert and Wrenja were here.",
      "Longshot was here."
    ]

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
  texts: () -> [
      "Damn those gridbugs are fast!",
      "gridbugs are the worst :p",
      "*sigh* now the demons spew poison and run like hell. I suppose it only gets worse from here?",
      "DODGE THIS.",
      "Dammit, citizens, why must you dive into danger and run from me? Couldn't you do the opposite!?",
      "There is no justice in this killing floor. I pile up the bodies and nothing changes.",
      "I hope I never see a bigger grid bug. These ones are plenty bad enough.",
      "My FireWall burned that citizen but the gods didn't care. Why are they so capricious?",
      "Snatch this text from my hand, Grasshopper.",
      "Shoot, I shouldn't have stopped to read this scroll.",
      "This page almost unintentionally left almost blank."
    ]

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
    

