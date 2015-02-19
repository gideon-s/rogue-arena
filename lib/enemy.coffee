class window.Enemy extends window.Actor

    act: () ->
        next = @nextLocation()
        return unless @game.map.isOpen(next)
        if next.hasOtherActorType(this, Enemy)
            return
        @location = next

    nextLocation: () -> @location
    died: () -> @game.player.addScore()
    towardsPlayer: () -> @location.addDir(@playerXYDirection(8))
    awayFromPlayer: () -> @location.subtractDir(@playerXYDirection(8))
    randomDirection: () -> @location.addDir(Util.rand8Dir())
    playerDistance: () -> Util.distance(@location, @game.player.location)

    playerXYDirection: (topology) ->
        xDiff = @game.player.location.x - @location.x
        yDiff = @game.player.location.y - @location.y
        absXDiff = Math.abs xDiff
        absYDiff = Math.abs yDiff
        xDir = if absXDiff > 0 then xDiff / absXDiff else 0
        yDir = if absYDiff > 0 then yDiff / absYDiff else 0
        if topology == 4
            if absXDiff > absYDiff
                [xDir, 0]
            else
                [0, yDir]
        else
            [xDir, yDir]

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
        else
            @location
        
    calculateNextStep: () -> 
        if @direction?
            @direction = null
            @stepsLeft = @steps
        else
            @direction = @playerXYDirection(4)
            @stepsLeft = @steps
    died: () ->
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
        @location

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
        @game.player.addScore(10)

    struckBy: (entity) ->
        @hits -= 1
        if (entity != @game.player && @hits > 0)
            return
        super(entity)

class window.MinorDemon extends window.Enemy
    constructor: (game, location) ->
        super(game, location, "&", "red", 400)

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
        else
            @location
    died: () ->
        @game.player.addScore(10)

    struckBy: (entity) ->
        if (entity == @game.player)
            @dead = true
            return
        if (entity instanceof RescueProjectile)
            @dead = true
            return
        if (entity instanceof Projectile || entity instanceof Particle)
            if (entity.owner == @game.player)
                @game.player.destroy()
                @game.player.destroyedBy = this.constructor.name


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
        @location
    died: () ->
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
        @game.player.addScore(3)

class window.OrcBoss extends window.OrcCharger
    constructor: (game, location) ->
        @hits = 30
        super(game, location)
        @color = "cyan"
        @sigil = "O"
    died: () ->
        @game.player.addScore(50)

    struckBy: (entity) ->
        @hits -= 1
        if (entity != @game.player && @hits > 0)
            return
        super(entity)
