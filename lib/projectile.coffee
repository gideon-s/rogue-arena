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

class window.RescueProjectile extends window.Projectile # needed for other things to identify these

class window.Particle extends window.Actor
    constructor: (game,location, @owner, @maxLife = Util.rand(20), color = "yellow", @colorizor = new Colorizor()) ->
        super(game, location, "#", color, 20)

    act: () ->
        @color = @colorizor.color()
        nextLoc = @location.addDir Util.rand8Dir()
        @maxLife = @maxLife - 1
        if (nextLoc.hasOtherActorType(this, Particle) or @maxLife < 0 or nextLoc.hasOtherActor(this, @owner))
            @dead = true
            return
        @location = nextLoc
            
    struckBy: (entity) ->
        if (entity instanceof Particle) or (entity == @owner)
            return
        super(entity)


class window.UnmovingCloud extends window.Actor
    constructor: (game,location, @maxLife = 20, @colorizor = new Colorizor()) ->
        super(game, location, "#", @colorizor.color(), 1000)

    act: () ->
        @color = @colorizor.color()
        @maxLife = @maxLife - 1
        if @maxLife < 0
            @dead = true

class window.Ball extends window.Projectile
    
    constructor: (game, location, direction, owner, color = "white", maxLife = 30) ->
        @colorizor = new Colorizor()
        super(game, location, direction, owner, color, maxLife)

    act: () ->
        @color = @colorizor.color()
        super()

    died: () ->
        for dir in [0..7]
            xyDir = Util.xyDir(dir)
            firstLocation = @location.addDir(xyDir)
            @emit(firstLocation, xyDir)

    emit: (firstLocation, xyDir) ->
        new BallParticle(@game, firstLocation, xyDir, @owner, "red", Util.rand(3) + 1)

class window.BallParticle extends window.Ball 
    emit: (firstLocation, xyDir) ->
        new Particle(@game, firstLocation, @owner, Util.rand(5))

