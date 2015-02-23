
class window.AgingActor extends window.Actor
    constructor: (game, location, sigil, color, speed, @maxLife) ->
        super(game, location, sigil, color, speed)

    action: () ->
        if @dead 
            return
        @maxLife -= 1
        if @maxLife <= 0
            @died("old age")
            return
        @youngAction()  
        super      

class window.OwnedActorWithLifespan extends window.AgingActor
    constructor: (game, location, @owner, maxLife, sigil, color, speed) ->
        super(game, location, sigil, color, speed, maxLife)

    moveDirection: (direction) ->
        nextLoc = @location.addDir direction
        @moveTo(nextLoc)

class window.Projectile extends window.OwnedActorWithLifespan

    constructor: (game, location, owner, maxLife, sigil, color, speed, @direction) ->
        super(game, location, owner, maxLife, sigil, color, speed)

    youngAction: () -> @moveDirection @direction

class window.HomingProjectile extends window.Projectile
    constructor: (game, location, owner, maxLife, color, xyDir) ->
        super(game, location, owner, maxLife, "*", color, 50, xyDir)

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

    youngAction: () ->
        @target = @nearestMonster()
        if @target?
            dir = @actorXYDirection(8, @target)
        else
            dir = @direction
        @moveDirection dir


class window.RescueProjectile extends window.Projectile # needed for other things to identify these


class window.Particle extends window.OwnedActorWithLifespan
    constructor: (game, location, owner, maxLife = Util.rand(20), @colorizor = new Colorizor(), speed = 20) ->
        super(game, location, owner, maxLife, "#", @colorizor.color(), speed)

    youngAction: () ->
        nextLoc = @location.addDir Util.rand8Dir()
        @moveTo(nextLoc)

class window.UnmovingCloud extends window.AgingActor
    constructor: (game, location, maxLife = Util.rand(100) + 100, @colorizor = new Colorizor()) ->
        super(game, location, "#", @colorizor.color(), 100, maxLife)
    youngAction: () ->

class window.Ball extends window.Projectile
    
    constructor: (game, location, direction, owner, maxLife = 30) ->
        @colorizor = new Colorizor()
        super(game, location, owner, maxLife, "+", @colorizor.color(), 20, direction)

    died: (reason) ->
        super(reason)
        for dir in [0..7]
            xyDir = Util.xyDir(dir)
            firstLocation = @location.addDir(xyDir)
            @emit(firstLocation, xyDir)

    emit: (firstLocation, xyDir) ->
        new BallParticle(@game, firstLocation, xyDir, @owner, Util.rand(3) + 1)

class window.BallParticle extends window.Ball 
    emit: (firstLocation, xyDir) ->
        new Particle(@game, firstLocation, @owner, Util.rand(5))

