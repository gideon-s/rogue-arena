
class window.MinorDemon extends window.Actor

	constructor: (game, location) ->
		super(game, location, "&", "red", 400)

	act: () ->
		if Util.rand(4) == 0
			dir = ROT.DIRS[8][Util.rand(8)]
			nextLocation = @location.addDir(dir)
		else
			nextLocation = @location.pathToDestination(@game.player.location,@game.map)[0]
		return  unless @game.map.isOpen(nextLocation)
		if (_.find nextLocation.otherActors(this),(actor) => actor instanceof MinorDemon)
			return
		@location = nextLocation

	died: () ->
		@game.player.addScore()

