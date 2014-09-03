class window.Map

    constructor: (width, height) ->
        @width = width
        @height = height
       
        @map = new Array(width)
        @map = for x in [0...width]
            @map[x] = new Array(height)
        
    at: (pair) ->
        @map[pair[0]][pair[1]]

    setLocation: (pair, symbol) ->
        @map[pair[0]][pair[1]] = symbol

    isOpen: (pair) ->
        @at(pair)?

    locations: () ->
        result = []
        for x in [0...@width]
            for y in [0...@height]
                if @isOpen([x,y])
                    result.push [x,y]   
        result

    randomLocation: () ->
        Util.pickRandom(@locations())






        
   