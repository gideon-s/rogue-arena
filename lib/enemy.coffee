class window.Enemy extends window.Actor

    act: () ->
        next = @nextLocation()
        return  unless @game.map.isOpen(next)
        if next.hasOtherActorType(this, Enemy)
            return
        @location = next

    nextLocation: () ->
        @location

    died: () ->
        @game.player.addScore()

    towardsPlayer: () ->
        @location.addDir(@playerXYDirection(8))

    playerXYDirection: (topology) ->
        xDiff = @game.player.location.x - @location.x
        yDiff = @game.player.location.y - @location.y
        absXDiff = Math.abs xDiff
        absYDiff = Math.abs yDiff
        if topology == 4
            if absXDiff > absYDiff
                [xDiff / absXDiff, 0]
            else
                [0, yDiff / absYDiff]
        else
            [xDiff / absXDiff, yDiff / absYDiff]

class window.Gridbug extends window.Enemy

    constructor: (game, location, @steps = 5, sigil = "x") ->
        super(game, location, sigil, "green", 50)
        @direction = null
        @stepsLeft = 0
        
    nextLocation: () ->
        if @stepsLeft == 0
            @calculateNextStep()
        @stepsLeft = @stepsLeft - 1
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

class window.Boss1 extends window.Gridbug
    constructor: (game, location) ->
        super(game, location, 10, sigil = "X")

    calculateNextStep: () ->
        for dir in [0..7] by 2
            xyDir = Util.xyDir(dir)
            firstLocation = @location.addDir(xyDir)
            new Projectile(@game, firstLocation, xyDir, this, "red", 20)
        super()

class window.ElvenArcher extends window.Enemy
    constructor: (game, location) -> 
      super(game, location, "E", "blue", 200)

    nextLocation: () ->
        if Util.oneIn(20)
            @towardsPlayer()
        else if Util.oneIn(4)
            dir = @playerXYDirection(8)
            firstLocation = @location.addDir(dir)
            new Projectile(@game, firstLocation, dir, this, "cyan")
            @location
        else
            @location

class window.MinorDemon extends window.Enemy
    constructor: (game, location) ->
        super(game, location, "&", "red", 400)

    nextLocation: () ->
        if Util.oneIn(3)
            @location.addDir(Util.rand8Dir())
        else
            @towardsPlayer()


