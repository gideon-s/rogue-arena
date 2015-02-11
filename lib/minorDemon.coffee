class window.MinorDemon extends window.Enemy

    constructor: (game, location) ->
        super(game, location, "&", "red", 400)

    nextLocation: () ->
        if Util.rand(4) == 0
            dir = ROT.DIRS[8][Util.rand(8)]
            @location.addDir(dir)
        else
            @location.pathToDestination(@game.player.location,@game.map)[0]



