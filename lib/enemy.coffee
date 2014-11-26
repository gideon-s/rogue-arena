class window.Enemy extends window.Actor

	constructor: (location) ->
		super(location, "&", "red", 400)

	act: () ->
		path = @location.pathToDestination(Game.player.getLocation(),Game.map)
		@location = path[0]

	died: () ->
		Game.player.addScore()

