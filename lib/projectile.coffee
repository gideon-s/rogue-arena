class window.Projectile extends window.Actor

    constructor: (game,location,@direction, @owner, color = "yellow") ->
        super(game, location, "+", color, 190)

    act: () ->
        nextLoc = @location.addDir @direction
        if (nextLoc.hasOtherActor(this, @owner))
            @dead = true
            return
        @location = nextLoc
            
    struckBy: (entity) ->
        if entity == @owner 
            return
        super(entity)
