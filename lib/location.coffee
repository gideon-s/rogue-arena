class window.Location

	constructor: (pair) ->
		@x=pair[0]
		@y=pair[1]

	addDir: (dir) ->
		new Location [@x+dir[0],@y+dir[1]]

	pair: () ->
		[@x,@y]

	pathToDestination: (destination) ->

	nextStepToDestination: () ->
		


