class window.Enemy

	constructor: (location) ->
		@location = location
		@draw()

	getSpeed: () -> 100

	act: () ->

		path = @location.pathToDestination(Game.player.getLocation(),Game.map)
		if path.length < 2
			Game.engine.lock()
			alert "Game over - you were eaten by the dragon!"
		else
			Game.drawMapLocation @location
			@location = path[0]
			@draw()

	draw: () -> Game.draw @location, "&", "red"