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
    @dragon = @_createBeing(Enemy)

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

Game.init()