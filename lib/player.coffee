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
        @allowedKeys[ROT.VK_I] = 1
        @allowedKeys[ROT.VK_J] = 1
        @allowedKeys[ROT.VK_K] = 1
        @allowedKeys[ROT.VK_L] = 1
        window.addEventListener "keydown", this

    handleEvent: (e) ->
        return unless @allowedKeys[e.keyCode] == 1
        @lastCode[e.keyCode] = 1

    moveDir: (dirIndex) ->
        dir = ROT.DIRS[8][dirIndex]
        nextLocation = @location.addDir(dir)
        return  unless @game.map.isOpen(nextLocation)
        @location = nextLocation

    fire: (dirIndex) ->
        dir = ROT.DIRS[8][dirIndex]
        nextLocation = @location.addDir(dir)
        new Projectile(@game, nextLocation, dir, this)
        @shotsFired++

    addScore: () ->
        @score++
        @game.drawScore()

    keysPressed: (keys...) ->
        _.every(keys, (k) => @lastCode[k] == 1)

    clearKeys: (keys...) ->
        _.each(keys, (k) => @lastCode[k] = 0)

    wasdDirection: (w, a, s, d) ->
        if @keysPressed(w, s)
            @clearKeys(w, s)
        if @keysPressed(a, d)
            @clearKeys(a, d)
        if @keysPressed(w, d)
            direction = 1
        else if @keysPressed(d, s)
            direction = 3
        else if @keysPressed(s, a)
            direction = 5
        else if @keysPressed(a, w)
            direction = 7
        else if @keysPressed(w)
            direction = 0
        else if @keysPressed(d)
            direction = 2
        else if @keysPressed(s)
            direction = 4
        else if @keysPressed(a)
            direction = 6

    act: (e) ->
        return unless @lastCode? # skip act if the player isn't done being constructed yet
        moveDirection = @wasdDirection(ROT.VK_W, ROT.VK_A, ROT.VK_S, ROT.VK_D)
        fireDirection = @wasdDirection(ROT.VK_I, ROT.VK_J, ROT.VK_K, ROT.VK_L)
        @clearKeys.apply(this, _.keys(@allowedKeys))
        if moveDirection?
            @moveDir(moveDirection)
        if fireDirection?
            @fire(fireDirection)
 
