class window.Location

	constructor: (@game, pair) ->
		if not @game instanceof Game
			throw new Error("game not set to instance of Game")
		if pair.length != 2
			throw new Error("error in pair length: #{pair}")
		if typeof(pair[0]) != "number"
			throw new Error("First in pair is not a number: #{pair[0]}")
		if typeof(pair[1]) != "number"
			throw new Error("Second in pair is not a number: #{pair[1]}")
		@x=pair[0]
		@y=pair[1]

	addDir: (dir) ->
		new Location @game, [@x+dir[0],@y+dir[1]]

	pair: () ->
		[@x,@y]

	pathToDestination: (destination, map, topology=8) ->
		passableCallback = (x, y) => map.isOpen(new Location(@game, [x,y])) 
		dest = destination.pair()
		astar = new ROT.Path.AStar(dest[0], dest[1], passableCallback, topology: topology)
		path = []
		pathCallback = (x, y) => path.push new Location(@game, [x,y])
		astar.compute @x, @y, pathCallback
		path.shift()
		return path

	nextStepToDestination: (destination, map, topology=8) -> @pathToDestination(destination, map, topology)[0]
		
	drawOn: (display, character, color) ->
		display.draw @x, @y, character, color

	setOn: (map, symbol) ->
		if not Array.isArray(map)
			throw new Error("Map is not an array")
		map[@x][@y] = symbol

	on: (map) ->
		if not Array.isArray(map)
			throw new Error("Map is not an array")
		if not map[@x]?
			return undefined
		map[@x][@y]

	otherActors: (entity) ->
		_.filter(@game.actors, (actor)=>(actor != entity) && (_.isEqual actor.location, this))

	toString: ->
		"[ #{@x}, #{@y} ]"
