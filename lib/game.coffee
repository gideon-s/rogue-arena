window.Game =
  display: null
  oldMap: {} 
  map: new Map()
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
    freeCells = []
    digCallback = (x, y, value) ->
      return  if value
      @map.setSquare [x, y], "."
      key = Coordinates.create(x, y)
      @oldMap[key] = "."
      freeCells.push key

    digger.create digCallback.bind(@)
    @_generateBoxes freeCells
    @_drawWholeMap()
    @player = @_createBeing(Player, freeCells)
    @dragon = @_createBeing(dragon, freeCells)

  _createBeing: (what, freeCells) ->
    [x, y] = Coordinates.selectRandom(freeCells)
    new what(x, y)

  _generateBoxes: (freeCells) ->
    i = 0

    while i < 10
      key = Util.pickRandom(freeCells)
      @map.setSquare Coordinates.parse(key), "*"
      @oldMap[key] = "*"
      @ananas = key  unless i # first box contains the prize
      i++

  _drawWholeMap: (map) ->
    #for key of @oldMap
    #  [x, y] = Coordinates.parse(key)
    #  @display.draw x, y, @oldMap[key]

    for key, value of @map.locationKeys()
      if Util.isInteger(key)
        [x, y] = Coordinates.parse(value)
        @display.draw x, y, @map.at ([x,y])


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
  newKey = Coordinates.create(newX, newY)
  return  unless newKey of Game.map
  #Game.display.draw @_x, @_y, Game.oldMap[Coordinates.create(@_x , @_y)]
  Game.display.draw @_x, @_y, Game.map.at ([@_x,@_y])
  @_x = newX
  @_y = newY
  @_draw()
  window.removeEventListener "keydown", this
  Game.engine.unlock()

Player::_draw = ->
  Game.display.draw @_x, @_y, "@", "#ff0"

Player::_checkBox = ->
  key = Coordinates.create(@_x, @_y)
  unless Game.oldMap[key] is "*"
    console.log "There is no box here!"
  else if key is Game.ananas
    console.log "Hooray! You found the gem of success and won this game."
    Game.engine.lock()
    window.removeEventListener "keydown", this
  else
    console.log "This box is empty :-("

dragon = (x, y) ->
  @_x = x
  @_y = y
  @_draw()

dragon::getSpeed = ->  100

dragon::act = ->
  x = Game.player.getX()
  y = Game.player.getY()
  passableCallback = (x, y) ->
    x + "," + y of Game.oldMap # // ToDO use Coordinates

  astar = new ROT.Path.AStar(x, y, passableCallback,
    topology: 4
  )
  path = []
  pathCallback = (x, y) ->
    path.push [x,y]

  astar.compute @_x, @_y, pathCallback
  path.shift()
  console.log "path length is #{path.length}"
  if path.length < 2
    Game.engine.lock()
    alert "Game over - you were eaten by the dragon!"
  else
    x = path[0][0]
    y = path[0][1]
    Game.display.draw @_x, @_y, Game.oldMap[Coordinates.create(@_x, @_y)]
    @_x = x
    @_y = y
    @_draw()

dragon::_draw = ->
  Game.display.draw @_x, @_y, "&", "red"

Game.init()