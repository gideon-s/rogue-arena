class window.Enemy

	constructor: (location) ->
		@location = location
		@draw()
		window.setTimeout (=> @act()), 1000 

	getSpeed: () -> 100

	act: () ->
		console.log (@location)
		path = @location.pathToDestination(Game.player.getLocation(),Game.map)
		if path.length < 2
			#Game.engine.lock()
			alert "Game over - you were eaten by the dragon!"
		else
			Game.drawMapLocation @location
			@location = path[0]
			@draw()
			window.setTimeout (=> @act()), 1000 
			
	draw: () -> Game.draw @location, "&", "red"