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

class window.Particle extends window.Actor
    constructor: (game,location, @owner, @maxLife = Util.rand(20), color = "yellow", @colorizor = new Colorizor()) ->
        super(game, location, "#", color, 20)

    act: () ->
        console.log @owner
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

class window.Grenade extends window.Projectile
    
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
        new GrenadeParticle(@game, firstLocation, xyDir, @owner, "red", 4)

class window.GrenadeParticle extends window.Grenade 
    emit: (firstLocation, xyDir) ->
        new Particle(@game, firstLocation, @owner, Util.rand(6))

