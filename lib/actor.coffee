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
			return
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
		@dead = true
		@destroyedBy = entity.constructor.name
		entity.destroy()
		entity.destroyedBy = this.constructor.name