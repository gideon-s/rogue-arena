class window.Map

    constructor: (@game, @width, @height) -> 
        @map = []
        for x in [0...@width]
            @map[x] = new Array(@height)
        for x in [0...@width]
            for y in [0...@height]
                @map[x][y] = new Location(@game, this, [x,y])
        @noLocation = new NoLocation()
      
    isOpen: (location) ->
        location.isOpen()

    lookupLocation: (pair) ->
        xRow = @map[pair[0]]
        unless xRow? 
            return @noLocation
        result = xRow[pair[1]]
        if result?
            result
        else
            @noLocation

    locations: () ->
        result = []
        for x in [0...@width]
            for y in [0...@height]
                result.push @lookupLocation([x, y])
        result

    randomLocation: () ->
        Util.pickRandom(@locations())

    randomEdgeLocation: () ->
        Util.pickRandom(@edgeLocations())

    edgeLocations: () ->
        result = []
        for x in [0...@width]
            result.push @lookupLocation([x, 0])
            result.push @lookupLocation([x, (@height - 1)])
        for y in [1...(@height - 1)]
            result.push @lookupLocation([0, y])
            result.push @lookupLocation([(@width - 1), y])
        result     
