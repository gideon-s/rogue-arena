class window.Map

    constructor: (width, height) ->
        @width = width
        @height = height
       
        @map = new Array(width)
        @map = for x in [0...width]
            @map[x] = new Array(height)
        
    at: (location) ->
        location.on(@map)

    setLocation: (location, symbol) ->
        location.setOn(@map, symbol)
        
    isOpen: (location) ->
        @at(location)?

    locations: () ->
        result = []
        for x in [0...@width]
            for y in [0...@height]
                location = new Location([x,y])
                if @isOpen(location)
                    result.push location   
        result

    randomLocation: () ->
        Util.pickRandom(@locations())





        
   