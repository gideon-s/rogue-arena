
class window.Game 
  
  @init: () ->
    @game = new Game()

  constructor: ->
    @actorId = 0
    @height = 60
    @width = 140
    @map = new Map(this, @width, @height - 1)
    @actors = []
    @display = new ROT.Display width: @width, height: @height, spacing: 1.1, fontSize: 12
    document.body.appendChild @display.getContainer()
    @drawWholeMap()
    @player = new Player(this, @map.lookupLocation([70, 30]))
    @spawner = new Spawner(this)
    @spawner.spawn(1000)
    @drawScore() 

  nextActorId: () ->
    @actorId += 1
    @actorId

  drawWholeMap: ->
    _.each @map.locations(), (location) =>  
      @draw(location)

  draw: (location)  ->
    if location instanceof NoLocation
      throw new Error("not a real location?")
    location.drawOn @display

  drawScore: () ->
    if @player?
      text = "Score: #{@player.score}"
      text += " #{@spawner.level().constructor.name}"
      text += " MainWeapon #{@player.weapons['main'].constructor.name}"
      _.each @player.modKeys, (mod) => 
        weapon = @player.weapons[mod]
        text += " #{mod}Weapon: #{if weapon? then weapon.constructor.name else 'none'}"
      @display.drawText(5, 0, text + " #{@actors.length} .........................", 1000)
      if @player.dead
            @display.drawText(@height/2, 5, "You have died.  Game Over. Score: #{@player.score} Killed By A: #{@player.destroyedBy} Press [ESC] to restart");

  died: (entity) ->
    Util.removeFromArray @actors, entity

  gameOver:() ->
    @display.drawText(@height/2, 5, "You have died.  Game Over. Score: #{@player.score} Killed By A: #{@player.destroyedBy} Press [ESC] to restart");
    window.addEventListener "keydown", this 
      
  handleEvent: (e) ->
    if e.keyCode is ROT.VK_ESCAPE
      location.reload()
      return

  nextAction: (action, speed) ->
    window.setTimeout (-> action()), speed
    