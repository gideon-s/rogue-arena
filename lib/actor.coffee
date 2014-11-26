class window.Actor

	constructor: (@location, @sigil, @color, @speed) ->
    @dead = false
    Game.actors.push this
    @action()

	action: () ->
		Game.drawMapLocation @location
		if Game.player? && Game.player.dead
			Game.gameOver()	
			return
		if @dead 
			Game.died(this)
			return
		@act()
		if not Game.map.isOpen(@location)
			@dead = true
			return
		Game.enters this
		@draw()	
		window.setTimeout (=> @action()), @speed
	
	died:() ->
		#no op

	draw: () -> Game.draw @location, @sigil, @color

	destroy: () ->
		@dead = true

	struckBy: (entity) ->
		@dead = true
		entity.destroy()
