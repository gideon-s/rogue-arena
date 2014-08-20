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
