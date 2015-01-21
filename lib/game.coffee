window.Game =
  display: null
  map: new Map(80,25)
  player: null
  actors: []
  prize: null
  init: ->
    @display = new ROT.Display spacing: 1.1
    document.body.appendChild @display.getContainer()
    @drawWholeMap()
    @player = new Player(@map.randomLocation())
    @spawn()
    @drawScore()

  drawWholeMap: ->
    _.each @map.locations(), (location) =>  
      @drawMapLocation(location)

  drawMapLocation: (location) ->
    @draw location, @map.at(location)

  draw: (location, character, color)  ->
    location.drawOn @display, character, color

  drawScore: () ->
    Game.display.drawText(5, 0, "Score: #{@player.score}")

  enters: (entity) ->
    console.log "entity #{entity}"
    console.log "#{entity.location}"
    _.each entity.location.otherActors(entity),(actor) =>
        actor.struckBy(entity)

  died: (entity) ->
    @actors = _.without @actors,entity
    entity.died()

  spawn: () ->
    @actors.push new Enemy(Game, @map.randomEdgeLocation())
    window.setTimeout (=> @spawn()), 1000 
    
  gameOver:() ->
    Game.display.drawText(5, 5, "You have died.  Game Over. Score: #{@player.score} Press [ESC] to restart");
    window.addEventListener "keydown", this 
      
  handleEvent: (e) ->
    code = e.keyCode
    # 27=escape
    if code is 27
      location.reload()
      return

  nextAction: (action, speed) ->
    window.setTimeout (-> action()), speed
    
Game.init()