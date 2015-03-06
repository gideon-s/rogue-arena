class window.Actor

    constructor: (@game, @location, @sigil, @color, @speed) ->
        @id = @game.nextActorId()
        @dead = false
        if @location instanceof NoLocation
            return
        @game.actors.push this
        @location.arriving this
        @action()

    action: () ->
        if @colorizor? 
            @color = @colorizor.color()
            @game.draw(@location)       
        if @game.player? && @game.player.dead
            @game.gameOver()    
        unless @dead
            @act()
        if @game.halt? and @game.halt
            return
        unless @dead
            @game.nextAction (=> @action()), @speed
        
    died: (reason) ->
        #console.log "#{this.constructor.name} #{this.id} killed by #{reason}"
        @dead = true
        @destroyedBy = reason
        @location.leaving(this)
        @game.died(this)

    act:() -> #no op

    hitBy: (entity, hitBack) -> # the actual hit
        hitBack = if hitBack then " in hit back" else " in initial hit"
        if entity instanceof RescueProjectile
            return
        if entity.owner? && this == entity.owner
            return
        if @owner? && @owner == entity
            @died("struck owner#{hitBack}")
            return
        if @hits? && @hits > 0
            @hits -= 1
        else
            @died(entity.constructor.name + hitBack)

    struckBy: (entity) -> # when one actor moves into another
        @hitBy(entity, false)
        entity.hitBy(this, true)

    moveTo: (newLocation) ->
        unless newLocation? 
            return
        newLocation.struckBy(this)
        if not @dead and newLocation.isOpen()
            @location.leaving this
            @location = newLocation
            @location.arriving this

    locationDistance: (location) -> Util.distance(@location, location)
    actorXYDirection: (topology, actor) ->
        xDiff = actor.location.x - @location.x
        yDiff = actor.location.y - @location.y
        absXDiff = Math.abs xDiff
        absYDiff = Math.abs yDiff
        xDir = if absXDiff > 0 then xDiff / absXDiff else 0
        yDir = if absYDiff > 0 then yDiff / absYDiff else 0
        if topology == 4
            if absXDiff > absYDiff
                [xDir, 0]
            else
                [0, yDir]
        else if absXDiff > absYDiff * 2
            [xDir, 0]
        else if absYDiff > absXDiff * 2
            [0, yDir]
        else
            [xDir, yDir]

