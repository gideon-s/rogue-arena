class window.Map

    constructor: (@game, @width, @height) ->
        @map = new Array(@width)
        @map = for x in [0...@width]
            @map[x] = new Array(@height)
        for x in [0...@width]
            for y in [0...@height]
                @setLocation(new Location(@game, [x,y]), " ")
      
    at: (location) ->
        location.on(@map)

    setLocation: (location, symbol) ->
        location.setOn(@map, symbol)
        
    isOpen: (location) ->
        @at(location)?

    addIfOpen: (result, pair) ->
        location = new Location(@game, pair)
        if @isOpen(location)
            result.push location

    locations: () ->
        result = []
        for x in [0...@width]
            for y in [0...@height]
                @addIfOpen(result, [x, y])
        result

    randomLocation: () ->
        Util.pickRandom(@locations())

    randomEdgeLocation: () ->
        Util.pickRandom(@edgeLocations())

    edgeLocations: () ->
        result = []
        for x in [0...@width]
            @addIfOpen(result, [x, 0])  
            @addIfOpen(result, [x, (@height - 1)])   
        for y in [1...(@height - 1)]
            @addIfOpen(result, [0, y])  
            @addIfOpen(result, [(@width - 1), y])  
        result     





        
   