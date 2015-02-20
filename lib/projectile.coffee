class window.Projectile extends window.Actor

    constructor: (game,location,@direction, @owner, color = "yellow", @maxLife = 1000, speed = 20) ->
        super(game, location, "+", color, speed)

    act: () ->
        @maxLife = @maxLife - 1
        @moveDirection @direction

    moveDirection: (direction) ->
        nextLoc = @location.addDir direction
        if (nextLoc.hasOtherActor(this, @owner) or @maxLife < 0)
            @died()
            return
        @moveTo(nextLoc)

            
    struckBy: (entity) ->
        if entity == @owner 
            return
        super(entity)

class window.HomingProjectile extends window.Projectile
    constructor: (game, location, xyDir, owner, color, maxLife) ->
        super(game, location, xyDir, owner, color, maxLife, 50)
        @sigil = "*"

    nearestMonster: () ->
        closest = undefined
        for dir in [0..7] 
            for i in [1..4]
                look = @location.addDir Util.xyDir(dir), i
                monster = _.find(look.otherActors(this), (a) => a instanceof Enemy and not (a instanceof Citizen))
                if monster?
                    if closest?
                        currentClosestDistance = Util.distance closest, @location
                        monsterDistance = Util.distance closest, monster.location
                        if monsterDistance < currentClosestDistance
                            closest = monster
                    else
                        closest = monster
        closest

    act: () ->
        @maxLife = @maxLife - 1
       # unless @target? 
        @target = @nearestMonster()
        if @target?
            dir = @actorXYDirection(8, @target)
        else
            dir = @direction
        @moveDirection dir


class window.RescueProjectile extends window.Projectile # needed for other things to identify these


class window.Particle extends window.Actor
    constructor: (game,location, @owner, @maxLife = Util.rand(20), color = "yellow", @colorizor = new Colorizor()) ->
        super(game, location, "#", color, 20)

    act: () ->
        @color = @colorizor.color()
        nextLoc = @location.addDir Util.rand8Dir()
        @maxLife = @maxLife - 1
        if (nextLoc.hasOtherActorType(this, Particle) or @maxLife < 0 or nextLoc.hasOtherActor(this, @owner))
            @died()
            return
        @moveTo(nextLoc)
            
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
            @died()

class window.Ball extends window.Projectile
    
    constructor: (game, location, direction, owner, color = "white", maxLife = 30) ->
        @colorizor = new Colorizor()
        super(game, location, direction, owner, color, maxLife)

    act: () ->
        @color = @colorizor.color()
        super()

    died: () ->
        super
        for dir in [0..7]
            xyDir = Util.xyDir(dir)
            firstLocation = @location.addDir(xyDir)
            @emit(firstLocation, xyDir)

    emit: (firstLocation, xyDir) ->
        new BallParticle(@game, firstLocation, xyDir, @owner, "red", Util.rand(3) + 1)

class window.BallParticle extends window.Ball 
    emit: (firstLocation, xyDir) ->
        new Particle(@game, firstLocation, @owner, Util.rand(5))

