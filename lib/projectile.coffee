class window.Projectile extends window.Actor

	constructor: (game,location,@direction) ->
		super(game, location, "+", "yellow", 190)

	act: () ->
		@location = @location.addDir @direction
			