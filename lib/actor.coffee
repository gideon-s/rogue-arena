class window.Actor
	constructor: (@game, @location, @sigil, @color, @speed) ->
		console.log @location
		@dead = false
		@game.actors.push this
		@action()

	action: () ->
		@game.drawMapLocation @location
		if @game.player? && @game.player.dead
			@game.gameOver()	
			return
		if @dead 
			@game.died(this)
			return
		@act()
		if not @game.map.isOpen(@location)
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
		entity.destroy()
