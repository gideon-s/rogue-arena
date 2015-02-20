class window.Enemy extends window.Actor
 
    constructor: (game, location, sigil, color, speed) ->
        super(game, location, sigil, color, speed)

    act: () ->
        next = @nextLocation()
        if next? and not ((next instanceof Location) or (next instanceof NoLocation))
        	throw new Error("nextLocation returned #{next.constructor.name} instead of location!")
        if next? and not next.hasOtherActorType(this, Enemy)
            @moveTo(next)

    nextLocation: () -> @location
    died: () -> 
        super
        @game.player.addScore()
    towardsPlayer: () -> @location.addDir(@playerXYDirection(8))
    awayFromPlayer: () -> @location.subtractDir(@playerXYDirection(8))
    randomDirection: () -> @location.addDir(Util.rand8Dir())
    playerDistance: () -> @locationDistance @game.player.location
    playerXYDirection: (topology) -> @actorXYDirection(topology, @game.player)

class window.Gridbug extends window.Enemy

    constructor: (game, location, @steps = 5, sigil = "x") ->
        super(game, location, sigil, "green", 50)
        @direction = null
        @stepsLeft = 0
        
    nextLocation: () ->
        if @stepsLeft == 0
            @calculateNextStep()
        @stepsLeft -= 1
        if @direction?
            @location.addDir(@direction)
        
    calculateNextStep: () -> 
        if @direction?
            @direction = null
            @stepsLeft = @steps
        else
            @direction = @playerXYDirection(4)
            @stepsLeft = @steps
    died: () -> 
        super
        @game.player.addScore(2)

class window.GridBoss extends window.Gridbug
    constructor: (game, location) ->
        super(game, location, 10, sigil = "X")
        @hits = 10

    calculateNextStep: () ->
        for dir in [0..7] by 2
            xyDir = Util.xyDir(dir)
            firstLocation = @location.addDir(xyDir)
            if firstLocation.isOpen()
                new Projectile(@game, firstLocation, xyDir, this, "red", 20)
        super()

    struckBy: (entity) ->
        @hits -= 1
        if (entity != @game.player && @hits > 0)
            return
        super(entity)
    died: () -> 
        super
        @game.player.addScore(20)

class window.ElvenArcher extends window.Enemy
    constructor: (game, location) -> 
      super(game, location, "E", "blue", 200)
      @hits = 4

    fire: () ->
        dir = @playerXYDirection(8)
        firstLocation = @location.addDir(dir)
        if firstLocation.isOpen()
            new Projectile(@game, firstLocation, dir, this, "cyan", 30)
        return undefined

    nextLocation: () ->
        if @playerDistance() > 20
            if Util.oneIn(2)
                @towardsPlayer()
            else if Util.oneIn(3)
                @fire()
            else
                @randomDirection()
        else if @playerDistance() < 10
            if Util.oneIn(2)
                @awayFromPlayer()
            else if Util.oneIn(5)
                @randomDirection()
            else 
                @fire()
        else
            if Util.oneIn(5)
                @fire()
            else
                @randomDirection()
    died: () -> 
        super
        @game.player.addScore(10)

    struckBy: (entity) ->
        @hits -= 1
        if (entity != @game.player && @hits > 0)
            return
        super(entity)

class window.MinorDemon extends window.Enemy
    constructor: (game, location, color = "red", speed = 400) ->
        super(game, location, "&", color, speed)

    nextLocation: () ->
        if Util.oneIn(3)
            @randomDirection()
        else
            @towardsPlayer()


class window.MajorDemon extends window.MinorDemon
    constructor: (game, location) ->
        super(game, location, "Lime", 50)

    nextLocation: () ->
        if Util.oneIn(3)
            @randomDirection()
        else
            @towardsPlayer()


class window.Citizen extends window.Enemy
    constructor: (game, location) ->
        loop
            loc = game.map.randomLocation()
            break if Util.distance(loc, game.player.location) > 20
        super(game, loc, "@", "cyan", 100)

    nextLocation: () ->
        if Util.oneIn(3)
            @randomDirection()
    died: () -> 
        super
        @game.player.addScore(10)

    struckBy: (entity) ->
        if (entity == @game.player)
            @died()
            return
        if (entity instanceof RescueProjectile)
            @died()
            return
        if (entity instanceof Projectile || entity instanceof Particle)
            if (entity.owner == @game.player)
                @game.player.died()
                @game.player.destroyedBy = this.constructor.name
                @died()
                @destroyedBy = "player"
                entity.died()
                entity.destroyedBy = "citizen"
                

class window.Firebat extends window.Enemy
    constructor: (game, location) ->
        @moves = []
        super(game, location, "w", "orange", 50)
        
    nextLocation: () ->
        if @moves.length != 0  
            @nextFlap()
        else
            if Util.oneIn(2)
                @fire()
            else if Util.oneIn(4)
                @towardsPlayer()
            else if Util.oneIn(6)
                @startFlapAround()
            else
                @randomDirection()

    startFlapAround:() ->
        @moves = [1,1,3,3,5,5,7,7]
        if Util.oneIn(2)
            @moves.reverse()
        @nextFlap()

    nextFlap:() ->
        dir = @moves.shift()
        @location.addDir(Util.xyDir(dir))
            
    fire: () ->
        smokeLocation = @randomDirection()
        if smokeLocation.isOpen()
            smoke = new Particle(@game, smokeLocation, this, Util.rand(5))
            smoke.speed = 300
        return undefined
    died: () -> 
        super
        @game.player.addScore(5)

class window.OrcCharger extends window.Enemy
    constructor: (game, location) ->
        super(game, location, "o", "white", 100)

    nextLocation: () ->
        if @playerDistance() < 20
            @towardsPlayer()
        else
            @randomDirection()
    died: () -> 
        super
        @game.player.addScore(3)

class window.OrcBoss extends window.OrcCharger
    constructor: (game, location) ->
        @hits = 30
        super(game, location)
        @color = "white"
        @sigil = "O"
    died: () -> 
        super
        @game.player.addScore(50)

    struckBy: (entity) ->
        @hits -= 1
        if (entity != @game.player && @hits > 0)
            return
        super(entity)
