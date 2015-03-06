
class window.Game 
  
  @init: () ->
    @game = new Game()

  constructor: ->
    @actorId = 0
    @height = Math.floor($(window).height() / 15) - 1 
    @width = Math.floor($(window).width() / 9)
    @map = new Map(this, @width, @height - 1)
    @actors = []
    @display = new ROT.Display width: @width, height: @height + 2, spacing: 1.1, fontSize: 12
    $('#game').append @display.getContainer()
    @drawWholeMap()
    @player = new Player(this, @map.lookupLocation([Math.floor(@width / 2), Math.floor(@height / 2)]))
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
      text = ""
      if @player.hits?
        text += "Hits: #{@player.hits}"
      text += " Score: #{@player.score}"
      text += " #{@spawner.level().constructor.name}"
      text += " W: #{@player.weapons['main'].constructor.name}"
      _.each @player.modKeys, (mod) => 
        weapon = @player.weapons[mod]
        text += " #{mod.substring(0, 4)}W: #{if weapon? then weapon.constructor.name else 'none'}"
      @display.drawText(5, 0, text + " #{@actors.length} .........................", 1000)
      if @player.dead
            @display.drawText(30, 5, "You have died.  Game Over. Score: #{@player.score} Killed By A: #{@player.destroyedBy} Press [ESC] to restart");

  died: (entity) ->
    Util.removeFromArray @actors, entity

  gameOver:() ->
    @display.drawText(30, 5, "You have died.  Game Over. Score: #{@player.score} Killed By A: #{@player.destroyedBy} Press [ESC] to restart");
    window.addEventListener "keydown", this 
      
  handleEvent: (e) ->
    if e.keyCode is ROT.VK_ESCAPE
      location.reload()
      return

  nextAction: (action, speed) ->
    if not speed? 
      throw new Error("can't set timeout immediately!")
    if speed < 5 
      throw new Error("speed too low!")
    window.setTimeout (-> action()), speed
    