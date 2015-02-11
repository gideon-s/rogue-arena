class window.Enemy extends window.Actor

    act: () ->
        next = @nextLocation()
        return  unless @game.map.isOpen(next)
        if (_.find next.otherActors(this),(actor) => actor instanceof Enemy)
            return
        @location = next

    nextLocation: () ->
    	@location

    died: () ->
        @game.player.addScore()