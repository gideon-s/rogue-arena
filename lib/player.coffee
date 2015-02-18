class window.Player extends window.Actor

    constructor: (game, location) ->
        super(game, location, "@", "white", 100)
        @lastCode = {}
        @allowedWeapons = [window.Dart, window.RescueRay, window.ControlledBlink, window.FireBall, window.FireWall, window.SmokeTrail, window.MagicMissile, window.KnifeWall]
        @weapons = {}
        @modKeys = ['shiftKey', 'altKey', 'ctrlKey', 'metaKey']

        @changeWeapon()
        @score = 0
        @shotsFired = 0
        window.addEventListener "keydown", this
        window.addEventListener "keyup", this

    struckBy: (entity) ->
        if entity instanceof Citizen
            entity.struckBy this
        else
            super(entity)

    handleModifier: (e, mod) ->
        if e[mod]
            @lastCode[mod] = 1
        else
            @lastCode[mod] = 0

    handleEvent: (e) ->
        @handleModifier e, 'shiftKey'
        @handleModifier e, 'ctrlKey'
        @handleModifier e, 'altKey'
        @handleModifier e, 'metaKey'
        if e.type == "keydown"
            if e.keyCode == ROT.VK_U
                @changeWeapon()
            else
                @lastCode[e.keyCode] = 1
        else if e.type == "keyup"
            @lastCode[e.keyCode] = 0
        
    moveDir: (dirIndex) ->
        dir = ROT.DIRS[8][dirIndex]
        nextLocation = @location.addDir(dir)
        return  unless @game.map.isOpen(nextLocation)
        @location = nextLocation

    fire: (dirIndex) ->
        fired = false
        _.each @modKeys, (mod) =>
            if @keysPressed(mod)
                weapon = @weapons[mod]
                if weapon? 
                    weapon.fire(dirIndex)
                    fired = true
        unless fired
            @weapons['main'].fire(dirIndex)

    changeWeapon: () ->
        changed = false
        doChange = (mod) =>
            type = Util.rotate(@allowedWeapons)
            @weapons[mod] = new type(this)
            @game.drawScore()
            changed = true
        _.each @modKeys, (mod) =>
            if @keysPressed(mod)
                doChange(mod)

        unless changed
            doChange('main')
        
    addScore: (amount = 1) ->
        @score += amount
        @game.drawScore()

    keysPressed: (keys...) ->
        _.every(keys, (k) => @lastCode[k] == 1)

    clearKeys: (keys...) ->
        _.each(keys, (k) => @lastCode[k] = 0)

    wasdDirection: (w, a, s, d) ->
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
        if moveDirection?
            @moveDir(moveDirection)
        if fireDirection?
            @fire(fireDirection)
        if @keysPressed(ROT.VK_P)
            @addScore 10
            @game.spawner.current = @game.spawner.current.next()
 
