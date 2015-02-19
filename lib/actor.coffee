class window.Actor
	constructor: (@game, @location, @sigil, @color, @speed) ->
		@dead = false
		@game.actors.push this
		@age = 0
		@action()

	action: () ->
		@age++
		@game.drawMapLocation @location
		if @game.player? && @game.player.dead
			@game.gameOver()	
		if @dead 
			@game.died(this)
			return
		@act()
		if @dead 
			@game.died(this)
			return
		if not @game.map.isOpen(@location)
			@game.died(this)
			@dead = true
			return
		@game.enters this
		@draw()	
		@game.nextAction (=> @action()), @speed
		
	
	died:() ->
		#no op

	act:() ->
		#no op

	draw: () -> @game.draw @location, @sigil, @color

	destroy: () ->
		@dead = true

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

class window.Colorizor 
    constructor: (@colors = ["yellow", "red", "orange"]) ->
    color: () ->
        Util.pickRandom(@colors)
