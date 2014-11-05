class window.Projectile

	constructor: (location,direction) ->
		@location = location
		@direction = direction
		@act()
		@dead = false

	act: () ->
		Game.drawMapLocation @location
		if @dead 
			return
		@location = @location.addDir @direction
		if not Game.map.isOpen(@location)
			return
		Game.enters @location, this
		@draw()	
		window.setTimeout (=> @act()), 190
			
	draw: () -> Game.draw @location, "+", "yellow"

	destroy: () ->
		@dead = true