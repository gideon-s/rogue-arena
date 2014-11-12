class window.Enemy

	constructor: (location) ->
		@location = location
		@draw()
		@dead = false
		window.setTimeout (=> @act()), 1000 

	getSpeed: () -> 100

	act: () ->
		if @dead
			Game.died(this)
			Game.drawMapLocation @location
			return
		path = @location.pathToDestination(Game.player.getLocation(),Game.map)
		if path.length < 2		
			Game.player.dead = true
			Game.gameOver()	
		else
			Game.drawMapLocation @location
			@location = path[0]
			@draw()
			window.setTimeout (=> @act()), 400 
			
	draw: () -> Game.draw @location, "&", "red"

	struckBy: (entity) ->
		if _.isEqual @location, entity.location
			@dead = true
			entity.destroy()
