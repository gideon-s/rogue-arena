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
        @location.nextStepToDestination(@game.player.location,@game.map)

    playerXYDirection: (topology) ->
        nextLocation = @location.nextStepToDestination(@game.player.location, @game.map, topology)
        [nextLocation.x - @location.x, nextLocation.y - @location.y]

class window.Gridbug extends window.Enemy

    constructor: (game, location) ->
        super(game, location, "X", "green", 50)
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
            @stepsLeft = 5
        else
            @direction = @playerXYDirection(4)
            @stepsLeft = 3

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
            




