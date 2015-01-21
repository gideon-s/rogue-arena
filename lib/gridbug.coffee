class window.Gridbug extends window.Actor

	constructor: (game, location) ->
		super(game, location, "X", "purple", 400)

	act: () ->
		if Util.rand(4) == 0
			dir = ROT.DIRS[4][Util.rand(4)]
			nextLocation = @location.addDir(dir)
		else
			nextLocation = @location.pathToDestination(@game.player.location,@game.map,4)[0]
		return  unless @game.map.isOpen(nextLocation)
		if (_.find nextLocation.otherActors(this),(actor) => actor instanceof Enemy)
			return
		@location = nextLocation

	died: () ->
		@game.player.addScore()

