class window.Map

    constructor: () ->
        @squares = {}
        console.log "Being Constructed, yo"

    fromPair: (pair) ->
        pair[0] + "," + pair[1]

    setSquare: (pair, symbol) ->
        @squares[@fromPair pair] = symbol

    at: (pair) ->
        @squares[@fromPair(pair)]

    locationKeys: () ->
    	Object.keys @squares    

    isOpen: (pair) ->
        @at(pair)?

    randomLocation: () ->
        Coordinates.selectRandom(@locationKeys())

class window.NewMap

    constructor: (width, height) ->
        
        @map = new Array(width)
        @map = for x in [0...width]
            @map[x] = new Array(height)
        
    at: (pair) ->
        @map[pair[0]][pair[1]]

    setLocation: (pair, symbol) ->
        @map[pair[0]][pair[1]] = symbol

    isOpen: (pair) ->
        @at(pair)?

   