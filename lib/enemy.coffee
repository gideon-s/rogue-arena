class window.Enemy extends window.Actor

	constructor: (location) ->
		super(location, "&", "red", 400)

	act: () ->
		path = @location.pathToDestination(Game.player.getLocation(),Game.map)
		if path.length < 2		
			Game.player.dead = true
			Game.gameOver()	
		else
			@location = path[0]

	died: () ->
		Game.player.addScore()

	struckBy: (entity) ->
		if _.isEqual @location, entity.location
			@dead = true
			entity.destroy()
