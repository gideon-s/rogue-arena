class window.Enemy extends window.Actor
 
    constructor: (game, location, sigil, color, speed, @score = 1) ->
        super(game, location, sigil, color, speed)

    act: () ->
        next = @nextLocation()
        if next? and not ((next instanceof Location) or (next instanceof NoLocation))
        	throw new Error("nextLocation returned #{next.constructor.name} instead of location!")
        if next? and not next.hasOtherActorType(this, Enemy)
            @moveTo(next)

    nextLocation: () -> @location
    died: (reason) -> 
        super(reason)
        @game.player.addScore(@score)
        if Util.oneIn 2
            new Item @game, @location
    towardsPlayer: () -> @location.addDir(@playerXYDirection(8))
    awayFromPlayer: () -> @location.subtractDir(@playerXYDirection(8))
    randomDirection: () -> @location.addDir(Util.rand8Dir())
    playerDistance: () -> @locationDistance @game.player.location
    playerXYDirection: (topology) -> @actorXYDirection(topology, @game.player)

class window.Gridbug extends window.Enemy

    constructor: (game, location, @steps = 5, sigil = "x", score = 2) ->
        super(game, location, sigil, "green", 50, score)
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

class window.GridBoss extends window.Gridbug
    constructor: (game, location) ->
        super(game, location, 10, sigil = "X", score = 20)
        @hits = 10

    calculateNextStep: () ->
        for dir in [0..7] by 2
            xyDir = Util.xyDir(dir)
            firstLocation = @location.addDir(xyDir)
            if firstLocation.isOpen()
                new Projectile(@game, firstLocation, this, 20, "+", "red", 20, xyDir)
        super()

class window.ElvenArcher extends window.Enemy
    constructor: (game, location) -> 
      super(game, location, "E", "blue", 200, score = 10)
      @hits = 2

    fire: () ->
        dir = @playerXYDirection(8)
        firstLocation = @location.addDir(dir)
        if firstLocation.isOpen()
            new Projectile(@game, firstLocation, this, 30, "+", "cyan", 20, dir)
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

class window.MinorDemon extends window.Enemy
    constructor: (game, location, color = "red", speed = 400, score = 1) ->
        super(game, location, "&", color, speed, score)

    nextLocation: () ->
        if Util.oneIn(3)
            @randomDirection()
        else
            @towardsPlayer()

class window.PufferDemon extends window.MinorDemon
    constructor: (game, location) ->
        super(game, location, "DarkRed", 200, score = 7)
    died: (reason) ->
        super(reason)
        new Ball(@game, @location, [0, 0], this, 30)

class window.MajorDemon extends window.MinorDemon
    constructor: (game, location) ->
        super(game, location, "Lime", 50, 5)

    nextLocation: () ->
        if Util.oneIn 3
            smokeLocation = @awayFromPlayer()
            new Particle(@game, smokeLocation, this, Util.rand(5) + 3, Colors.poison, 200)
        super()

class window.Citizen extends window.Enemy
    constructor: (game, location) ->
        tries = 0
        loop
            loc = game.map.randomLocation()
            break if Util.distance(loc, game.player.location) > 20 or tries > 100
            tries += 1
        super(game, loc, "@", "cyan", 100, 10)

    nextLocation: () ->
        if Util.oneIn(3)
            @randomDirection()

    hitBy: (entity) ->
        if (entity == @game.player)
            @died("Saved!")
            return
        if (entity instanceof RescueProjectile)
            @died("Saved!")
            return
        if entity.owner? and entity.owner == @game.player
            @game.player.died("shooting a townie! Don't shoot the populace!")
            @died("player projectile!")
            return
        super(entity)                

class window.Firebat extends window.Enemy
    constructor: (game, location) ->
        @moves = []
        super(game, location, "w", "orange", 50, 5)
        
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
            new Particle(@game, smokeLocation, this, Util.rand(5) + 3, Colors.fire, 200)
        return undefined

class window.OrcCharger extends window.Enemy
    constructor: (game, location, score = 3) ->
        super(game, location, "o", "white", 100, score)

    nextLocation: () ->
        if @playerDistance() < 20
            @towardsPlayer()
        else
            @randomDirection()

class window.OrcBoss extends window.OrcCharger
    constructor: (game, location) ->
        @hits = 20
        super(game, location, 50)
        @color = "white"
        @sigil = "O"
        @charging = false

    nextLocation: () ->
        if @hits < 18
            @charging = true
        if @playerDistance() < 20 || @charging
            @towardsPlayer()
        else
            @randomDirection()

class window.Ghost extends window.Enemy
    constructor: (game, location) ->
        @hits = 100
        super(game, location, "@", "DimGray", 500)
    nextLocation: () ->
        l = @randomDirection()
        @game.player.location = l
        l
    died: (reason) ->
        @game.halt = true

