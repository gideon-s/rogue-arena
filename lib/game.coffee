class window.Game 
  
  @init: () ->
    @game = new Game()

  constructor: ->
    @map = new Map(this,80,25)
    console.log "created map"
    @actors = []
    @display = new ROT.Display spacing: 1.1
    document.body.appendChild @display.getContainer()
    @drawWholeMap()
    @player = new Player(this,@map.randomLocation())
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
    @display.drawText(5, 0, "Score: #{@player.score}")

  enters: (entity) ->
    _.each entity.location.otherActors(entity),(actor) =>
        actor.struckBy(entity)

  died: (entity) ->
    @actors = _.without @actors,entity
    entity.died()

  spawn: () ->
    if Util.oneIn(2)
      type = Enemy
    else
      type = Gridbug
    @actors.push new type(this, @map.randomEdgeLocation())
    window.setTimeout (=> @spawn()), 1000 
    
  gameOver:() ->
    @display.drawText(5, 5, "You have died.  Game Over. Score: #{@player.score} Press [ESC] to restart");
    window.addEventListener "keydown", this 
      
  handleEvent: (e) ->
    code = e.keyCode
    # 27=escape
    if code is 27
      location.reload()
      return

  nextAction: (action, speed) ->
    window.setTimeout (-> action()), speed
    