window.Game =
  display: null
  map: new Map(ROT.DEFAULT_WIDTH,ROT.DEFAULT_HEIGHT)
  engine: null
  player: null
  dragon: null
  ananas: null
  init: ->
    @display = new ROT.Display spacing: 1.1
    document.body.appendChild @display.getContainer()
    @_generateMap()
    scheduler = new ROT.Scheduler.Simple()
    scheduler.add @player, true
    scheduler.add @dragon, true
    @engine = new ROT.Engine scheduler
    @engine.start()

  _generateMap: ->
    digger = new ROT.Map.Digger()
    digCallback = (x, y, value) ->
      return if value
      @map.setLocation([x,y],".")

    digger.create digCallback.bind(@)
    @_generateBoxes()
    @_drawWholeMap()
    @player = @_createBeing(Player)
    @dragon = @_createBeing(Dragon)

  _createBeing: (what) ->
    [x, y] = @map.randomLocation()
    new what(x, y)

  _generateBoxes: () ->
    i = 0

    while i < 10
      randLoc = @map.randomLocation()
      @map.setLocation(randLoc,"*")
      @ananas = randLoc  unless i # first box contains the prize
      i++

  _drawWholeMap: ->
    for location in @map.locations()
      @display.draw location[0],location[1], @map.at(location)

Player = (x, y) ->
  @_x = x
  @_y = y
  @_draw()

Player::getSpeed = ->  100
Player::getX = ->  @_x
Player::getY = ->  @_y

Player::act = ->
  Game.engine.lock()
  window.addEventListener "keydown", this

Player::handleEvent = (e) ->
  code = e.keyCode
  # 13=space, 32=enter
  if code is 13 or code is 32
    @_checkBox()
    return
  keyMap = {}
  # Up arrow
  keyMap[38] = 0
  # Up key
  keyMap[33] = 1
  # Right Arrow
  keyMap[39] = 2
  # Page down
  keyMap[34] = 3
  # Down Arrow
  keyMap[40] = 4
  keyMap[35] = 5
  keyMap[37] = 6
  keyMap[36] = 7
  
  # one of numpad directions? 
  return  unless code of keyMap
  
  # is there a free space? 
  dir = ROT.DIRS[8][keyMap[code]]
  newX = @_x + dir[0]
  newY = @_y + dir[1]
  return  unless Game.map.isOpen([newX,newY])
  Game.display.draw @_x, @_y, Game.map.at([@_x , @_y])
  @_x = newX
  @_y = newY
  @_draw()
  window.removeEventListener "keydown", this
  Game.engine.unlock()

Player::_draw = ->
  Game.display.draw @_x, @_y, "@", "#ff0"

Player::_checkBox = ->
  playerLocation = [@_x,@_y]
  unless Game.map.at(playerLocation) is "*"
    console.log "There is no box here!"
  else if playerLocation is Game.ananas
    console.log "Hooray! You found the gem of success and won this game."
    Game.engine.lock()
    window.removeEventListener "keydown", this
  else
    console.log "This box is empty :-("

Dragon = (x, y) ->
  @_x = x
  @_y = y
  @_draw()

Dragon::getSpeed = ->  100

Dragon::act = ->
  x = Game.player.getX()
  y = Game.player.getY()
  passableCallback = (x, y) ->
    Game.map.isOpen([x,y]) 

  astar = new ROT.Path.AStar(x, y, passableCallback,
    topology: 4
  )
  path = []
  pathCallback = (x, y) ->
    path.push [x,y]

  astar.compute @_x, @_y, pathCallback
  path.shift()
  if path.length < 2
    Game.engine.lock()
    alert "Game over - you were eaten by the dragon!"
  else
    x = path[0][0]
    y = path[0][1]

    Game.display.draw @_x, @_y, Game.map.at([@_x, @_y])
    @_x = x
    @_y = y
    @_draw()

Dragon::_draw = ->
  Game.display.draw @_x, @_y, "&", "red"

Game.init()