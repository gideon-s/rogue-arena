class window.Location

    constructor: (@game, @map, pair) ->
        if not @game instanceof Game
            throw new Error("game not set to instance of Game")
        if pair.length != 2
            throw new Error("error in pair length: #{pair}")
        if typeof(pair[0]) != "number"
            throw new Error("First in pair is not a number: #{pair[0]}")
        if typeof(pair[1]) != "number"
            throw new Error("Second in pair is not a number: #{pair[1]}")
        @x=pair[0]
        @y=pair[1]
        @contents = []

    isOpen: () -> @otherActors(undefined).length == 0
    pair: () -> [@x,@y]

    subtractDir: (dir, amount = 1) -> @addDir(dir, amount * -1)
    addDir: (dir, amount = 1) ->
        @map.lookupLocation [@x + (amount * dir[0]), @y + (amount * dir[1])]

    pathToDestination: (destination, map, topology=8) ->
        passableCallback = (x, y) => map.isOpen(@map.lookupLocation [x, y]) 
        dest = destination.pair()
        astar = new ROT.Path.AStar(dest[0], dest[1], passableCallback, topology: topology)
        path = []
        pathCallback = (x, y) => path.push @map.lookupLocation [x, y]
        astar.compute @x, @y, pathCallback
        path.shift()
        return path

    nextStepToDestination: (destination, map, topology = 8) -> @pathToDestination(destination, map, topology)[0]
        
    pickUp: () ->
    	if @contents.length == 0
    		return
    	items = _.filter(@contents, (content) => content instanceof Item)
    	if items.length == 0
    		return
    	item = _.last items
    	@leaving(item)
    	item.pickedUp()

    drawOn: (display) ->
        if @contents.length == 0
            character = " "
            color = "black"
        else
            top = _.last(@contents)
            character = top.sigil
            color = top.color
        display.draw @x, @y + 1, character, color # the plus one allows the score status line to stay pristine

    otherActors: (entity) ->
        _.filter(@contents, (content) => content instanceof Actor && (content != entity))

    hasOtherActor: (theActor, other) ->
        _.find @otherActors(theActor), (actor) => actor == other

    hasOtherActorType: (theActor, type) ->
        _.find @otherActors(theActor), (actor) => actor instanceof type

    leaving: (entity) -> 
        Util.removeFromArray(@contents, entity)
        @game.draw(this)

    arriving:(entity) -> 
        @contents.push entity
        @game.draw(this)

    struckBy: (entity) ->
        _.each @otherActors(entity), (actor) -> actor.struckBy(entity)

    toString: ->
        "[ #{@x}, #{@y} ]"



class window.NoLocation 
    isOpen: () -> false
    hasOtherActor: (unused...) -> false
    hasOtherActorType: (unused...) -> false
    struckBy: (unused...) -> 
    otherActors: (unused...) -> []
