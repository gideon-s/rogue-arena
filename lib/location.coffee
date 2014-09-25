class window.Location

	constructor: (pair) ->
		@x=pair[0]
		@y=pair[1]

	addDir: (dir) ->
		new Location [@x+dir[0],@y+dir[1]]

	pair: () ->
		[@x,@y]

	pathToDestination: (destination, map) ->
		passableCallback = (x, y) -> map.isOpen(new Location([x,y])) 
		dest = destination.pair()
		astar = new ROT.Path.AStar(dest[0], dest[1], passableCallback, topology: 8)
		path = []
		pathCallback = (x, y) -> path.push new Location [x,y]
		astar.compute @x, @y, pathCallback
		path.shift()
		return path

	nextStepToDestination: (destination, map) -> @pathToDestination(destination, map)[0]
		
	drawOn: (display, character, color) ->
        display.draw @x, @y, character, color

    setOn: (map, symbol) -> map[@x][@y] = symbol
    on: (map) -> map[@x][@y]

