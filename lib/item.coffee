class window.Item 
    constructor: (@game, @location) ->
        @sigil = "$"
        @color = "Yellow"
        @location.arriving this
        @clearString = new Array(@game.width).join(" ")

    pickedUp: () ->
        for i in [0..@game.width] 
            @game.display.draw(i, @game.height, " ")
        @game.display.drawText(5, @game.height, @game.spawner.level().text() + @clearString, 1000);