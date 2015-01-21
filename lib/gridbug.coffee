class window.Gridbug extends window.Actor

    constructor: (game, location) ->
        super(game, location, "X", "green", 50)
        @direction = null
        @stepsLeft = 0

    step: () ->
        @stepsLeft = @stepsLeft - 1
        return unless @direction?
        nextLocation = @location.addDir(@direction)
        return unless @game.map.isOpen(nextLocation)
        if (_.find nextLocation.otherActors(this),(actor) => actor instanceof Gridbug)
            return
        @location = nextLocation

    act: () ->
        if @stepsLeft == 0
            @calculateNextStep()
        @step()

        
    calculateNextStep: () -> # at 10, 10      15, 15
        if @direction?
            @direction = null
            @stepsLeft = 5
        else
            nextLocation = @location.nextStepToDestination(@game.player.location, @game.map, 4)
            @direction = [nextLocation.x - @location.x, nextLocation.y - @location.y]
            @stepsLeft = 3

    died: () ->
        @game.player.addScore()

