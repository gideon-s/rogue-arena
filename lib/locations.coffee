class window.Location
	constructor: (x,y) ->

	@addDir: (location, dir) ->
		[location[0]+dir[0],location[1]+dir[1]]
