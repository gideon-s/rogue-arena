class window.Projectile extends window.Actor

    constructor: (game,location,@direction, @owner, color = "yellow", @maxLife = 1000) ->
        super(game, location, "+", color, 20)

    act: () ->
        nextLoc = @location.addDir @direction
        @maxLife = @maxLife - 1
        if (nextLoc.hasOtherActor(this, @owner) or @maxLife < 0)
            @dead = true
            return
        @location = nextLoc
            
    struckBy: (entity) ->
        if entity == @owner 
            return
        super(entity)
