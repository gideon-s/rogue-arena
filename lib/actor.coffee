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
		if @dead 
			@game.died(this)
			return
		@act()
		if @dead 
			@game.died(this)
			return
		@game.nextAction (=> @action()), @speed
		
	
	died:() -> @location.leaving(this)
	act:() -> #no op
	destroy: () -> @dead = true

	struckBy: (entity) ->
		if entity instanceof RescueProjectile
			return
		if @hits? && @hits > 0
			@hits -= 1
		else
			@dead = true
			@destroyedBy = entity.constructor.name
		if entity.hits? && entity.hits > 0
			entity.hits -= 1
		else
			entity.destroy()
			entity.destroyedBy = this.constructor.name

	moveTo: (newLocation) ->
		unless newLocation? 
			return
		newLocation.struckBy(this)
		if newLocation.isOpen()
			@location.leaving this
			@location = newLocation
			@location.arriving this
			
class window.Colorizor 
    constructor: (@colors = ["yellow", "red", "orange"]) ->
    color: () ->
        Util.pickRandom(@colors)
