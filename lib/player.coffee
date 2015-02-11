class window.Player extends window.Actor

    constructor: (game, location) ->
        super(game, location, "@", "white", 50)
        console.log "player constructor started"
        @score = 0
        @shotsFired = 0
        @lastCode = {}
        @allowedKeys = {}
        @allowedKeys[ROT.VK_W] = 1
        @allowedKeys[ROT.VK_A] = 1
        @allowedKeys[ROT.VK_S] = 1
        @allowedKeys[ROT.VK_D] = 1
        console.log @allowedKeys
        window.addEventListener "keydown", this

    handleEvent: (e) ->
        console.log @allowedKeys
        return unless @allowedKeys[e.keyCode] == 1
        console.log @lastCode
        @lastCode[e.keyCode] = 1
        console.log @lastCode

    moveDir: (dirIndex) ->
        dir = ROT.DIRS[8][dirIndex]
        nextLocation = @location.addDir(dir)
        return  unless @game.map.isOpen(nextLocation)
        @location = nextLocation

    fire: (dirIndex) ->
        dir = ROT.DIRS[8][dirIndex]
        nextLocation = @location.addDir(dir)
        new Projectile(@game, nextLocation,dir)
        @shotsFired++

    addScore: () ->
        @score++
        @game.drawScore()

    act: (e) ->
        console.log @lastCode
        if @lastCode[ROT.VK_W] == 1
            dir = 1
        @moveDir(dir)
 
