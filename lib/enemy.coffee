class window.Enemy extends window.Actor

	constructor: (location) ->
		super(Game, location, "&", "red", 400)

	act: () ->
		if Util.rand(4) == 0
			dir = ROT.DIRS[8][Util.rand(8)]
			nextLocation = @location.addDir(dir)
		else
			nextLocation = @location.pathToDestination(Game.player.getLocation(),Game.map)[0]
		@location = nextLocation

	died: () ->
		Game.player.addScore()

