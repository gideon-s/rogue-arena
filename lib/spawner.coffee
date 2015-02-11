class window.Spawner 
  
  constructor: (@game) ->

  score: () -> @game.player.score

  spawn: () ->
    type = @monsterChooser().monsterType()
    @game.actors.push new type(@game, @game.map.randomEdgeLocation())
    window.setTimeout (=> @spawn()), 1000 

  monsterChooser: () -> 
    if @score() < 10
      new Level1()
    else if @score() < 20
      new Level2()
    else
      new Level3()

class window.Level1
  monsterType: () -> 
    MinorDemon

class window.Level2
  monsterType: () ->
    if Util.oneIn(2)
      type = MinorDemon
    else
      type = Gridbug

class window.Level3
  monsterType: () ->
    if Util.oneIn(10)
      type = ElvenArcher
    else if Util.oneIn(3)
      type = Gridbug
    else 
      type = MinorDemon
 
    

