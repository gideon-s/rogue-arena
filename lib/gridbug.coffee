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
        
    calculateNextStep: () -> # at 10, 10      15, 15
        if @direction?
            @direction = null
            @stepsLeft = 5
        else
            nextLocation = @location.nextStepToDestination(@game.player.location, @game.map, 4)
            @direction = [nextLocation.x - @location.x, nextLocation.y - @location.y]
            @stepsLeft = 3