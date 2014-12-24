class window.Projectile extends window.Actor

	constructor: (location,@direction) ->
		super(Game, location, "+", "yellow", 190)

	act: () ->
		@location = @location.addDir @direction
			