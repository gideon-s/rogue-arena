class window.Item 
    constructor: (@game, @location) ->
        @sigil = "$"
        @color = "Yellow"
        @location.arriving this

    pickedUp: () ->
        @game.display.drawText(5, @game.height, "Picked up a scroll!");