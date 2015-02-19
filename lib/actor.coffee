class window.Actor
	constructor: (@game, @location, @sigil, @color, @speed) ->
		@dead = false
		@game.actors.push this
		@age = 0
		@location.arriving this
		@action()

	action: () ->
		@age++
		if @game.player? && @game.player.dead
			@game.gameOver()	
			#return # stop everything if player is dead
		unless @dead
			@act()
		unless @dead
			@game.nextAction (=> @action()), @speed
		
	died:() ->
		@dead = true
		@location.leaving(this)
		@game.died(this)

	act:() -> #no op

	struckBy: (entity) ->
		if this instanceof RescueProjectile or entity instanceof RescueProjectile
			return
		if @hits? && @hits > 0
			@hits -= 1
		else
			@died()
			@destroyedBy = entity.constructor.name
		if entity.hits? && entity.hits > 0
			entity.hits -= 1
		else
			entity.died()
			entity.destroyedBy = this.constructor.name

	moveTo: (newLocation) ->
		unless newLocation? 
			return
		newLocation.struckBy(this)
		if not @dead and newLocation.isOpen()
			@location.leaving this
			@location = newLocation
			@location.arriving this
			
class window.Colorizor 
    constructor: (@colors = ["yellow", "red", "orange"]) ->
    color: () ->
        Util.pickRandom(@colors)
