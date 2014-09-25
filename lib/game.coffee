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
    @generateMap()
    @generateBoxes()
    @drawWholeMap()
    @player = new Player(@map.randomLocation())
    @dragon = new Enemy(@map.randomLocation())
    scheduler = new ROT.Scheduler.Simple()
    scheduler.add @player, true
    scheduler.add @dragon, true
    @engine = new ROT.Engine scheduler
    @engine.start()

  generateMap: ->
    digger = new ROT.Map.Digger()
    digCallback = (x, y, value) ->
      return if value
      @map.setLocation(new Location([x,y]),".")

    digger.create digCallback.bind(@)

  generateBoxes: () ->
    i = 0

    while i < 10
      randLoc = @map.randomLocation()
      @map.setLocation(randLoc,"*")
      @ananas = randLoc  unless i # first box contains the prize
      i++

  drawWholeMap: ->
    for location in @map.locations()
      @drawMapLocation(location)

  drawMapLocation: (location) ->
    @draw location, @map.at(location)

  draw: (location, character, color)  ->
    location.drawOn @display, character, color
    

Game.init()