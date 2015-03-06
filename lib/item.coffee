class window.Item 
    constructor: (@game, @location, @options = {}) ->
        @sigil = @options.sigil
        @color = @options.color
        @location.arriving this

    message: (text) ->
        for i in [0..@game.width] 
            @game.display.draw(i, @game.height, " ")
        @game.display.drawText(5, @game.height, text, 1000)

    pickedUp: () ->

class window.Scroll extends window.Item
    constructor: (@location, options = {}) ->
        options.sigil ?= '?'
        options.color ?= 'yellow'
        super(@location.game, @location, options)

    pickedUp: () ->
        @message @game.spawner.level().text()

class window.OneUp extends window.Item
    constructor: (@location, options = {}) ->
        options.sigil ?= '%'
        options.color ?= 'cyan'
        super(@location.game, @location, options)

    pickedUp: () ->
        @game.player.hits ?= 0
        @game.player.hits += 1
        @message "I feel#{if @game.player.hits == 1 then '' else ' more'} protected!"
