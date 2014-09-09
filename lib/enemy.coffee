class window.Enemy

	constructor: (x, y) ->
		@_x = x
		@_y = y
		@draw()

	getSpeed: () ->  
		return 100

	act: () ->
		x = Game.player.getX()
		y = Game.player.getY()
		passableCallback = (x, y) ->
			Game.map.isOpen([x,y]) 

		astar = new ROT.Path.AStar(x, y, passableCallback,
			topology: 4
		)
		path = []
		pathCallback = (x, y) ->
			path.push [x,y]

		astar.compute @_x, @_y, pathCallback
		path.shift()
		if path.length < 2
			Game.engine.lock()
			alert "Game over - you were eaten by the dragon!"
		else
			x = path[0][0]
			y = path[0][1]

			Game.display.draw @_x, @_y, Game.map.at([@_x, @_y])
			@_x = x
			@_y = y
			@draw()

	draw: () ->
		Game.display.draw @_x, @_y, "&", "red"