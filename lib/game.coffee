class window.Game 
  
  @init: () ->
    @game = new Game()

  constructor: ->
    @height = 60
    @width = 140
    @map = new Map(this, @width, @height - 1)
    @actors = []
    @display = new ROT.Display width: @width, height: @height, spacing: 1.1, fontSize: 12
    document.body.appendChild @display.getContainer()
    @drawWholeMap()
    @player = new Player(this, new Location(this, [70, 30]))
    @spawner = new Spawner(this)
    @spawner.spawn(1000)
    @drawScore() 

  drawWholeMap: ->
    _.each @map.locations(), (location) =>  
      @drawMapLocation(location)

  drawMapLocation: (location) ->
    @draw location, @map.at(location)

  draw: (location, character, color)  ->
    location.drawOn @display, character, color

  drawScore: () ->
    if @player?
      text = "Score: #{@player.score}"
      text += " #{@spawner.level().constructor.name}"
      text += " MainWeapon #{@player.weapons['main'].constructor.name}"
      _.each @player.modKeys, (mod) => 
        weapon = @player.weapons[mod]
        text += " #{mod}Weapon: #{if weapon? then weapon.constructor.name else 'none'}"
      @display.drawText(5, 0, text + ".........................", 1000)

  enters: (entity) ->
    _.each entity.location.otherActors(entity), (actor) =>
        actor.struckBy(entity)

  died: (entity) ->
    @actors = _.without @actors, entity
    entity.died()

  gameOver:() ->
    @display.drawText(@height/2, 5, "You have died.  Game Over. Score: #{@player.score} Killed By A: #{@player.destroyedBy} Press [ESC] to restart");
    window.addEventListener "keydown", this 
      
  handleEvent: (e) ->
    if e.keyCode is ROT.VK_ESCAPE
      location.reload()
      return

  nextAction: (action, speed) ->
    window.setTimeout (-> action()), speed
    