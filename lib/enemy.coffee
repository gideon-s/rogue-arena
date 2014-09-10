class window.Enemy

	constructor: (location) ->
		@location = location
		@draw()

	getSpeed: () ->  
		return 100

	act: () ->
		playerLocation = Game.player.getLocation()
		passableCallback = (x, y) ->
			Game.map.isOpen([x,y]) 

		astar = new ROT.Path.AStar(playerLocation[0], playerLocation[1], passableCallback,
			topology: 4
		)
		path = []
		pathCallback = (x, y) ->
			path.push [x,y]

		astar.compute @location[0], @location[1], pathCallback
		path.shift()
		if path.length < 2
			Game.engine.lock()
			alert "Game over - you were eaten by the dragon!"
		else
			Game.drawMapLocation @location
			@location = path[0]
			@draw()

	draw: () ->
		Game.draw @location, "&", "red"