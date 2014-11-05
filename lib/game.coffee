window.Game =
  display: null
  map: new Map(ROT.DEFAULT_WIDTH,ROT.DEFAULT_HEIGHT)
  #engine: null
  player: null
  enemies: []
  prize: null
  init: ->
    @display = new ROT.Display spacing: 1.1
    document.body.appendChild @display.getContainer()
    @generateMap()
    @generateBoxes(10)
    @drawWholeMap()
    @player = new Player(@map.randomLocation())
    #@enemies.push new Enemy(@map.randomLocation())
    #@enemies.push new Enemy(@map.randomLocation())
    @spawn()
  generateMap: ->
    arena = new ROT.Map.Arena()
    arenaCallback = (x, y, value) ->
      return if value
      @map.setLocation(new Location([x,y])," ")
    arena.create arenaCallback.bind(@)

  generateBoxes: (num) ->
  
    _.each _.range(num), =>
      randLoc = @map.randomLocation()
      @map.setLocation(randLoc,"*")
      if @prize is null
        @prize = randLoc

  drawWholeMap: ->
    _.each @map.locations(), (location) =>  
      @drawMapLocation(location)

  drawMapLocation: (location) ->
    @draw location, @map.at(location)

  draw: (location, character, color)  ->
    location.drawOn @display, character, color

  enters: (location, entity) ->
    _.each @enemies,(enemy) =>
      enemy.struckBy(entity)

  died: (entity) ->
    @enemies = _.without @enemies,entity

  spawn: () ->
    @enemies.push new Enemy(@map.randomLocation())
    window.setTimeout (=> @spawn()), 1000 
    

Game.init()