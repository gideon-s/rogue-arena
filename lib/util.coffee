class window.Util

    @rotate: (a) ->
        newLast = a.shift()
        a.push newLast
        newLast

    @rand: (highNumber) -> 
        return Math.floor(ROT.RNG.getUniform() * highNumber)

    @pickRandom: (list) -> 
        list[@rand(list.length)]

    @oneIn: (number) ->
        Util.rand(number) == 0 
        
    @rand8Dir: () ->
        ROT.DIRS[8][Util.rand(8)]

    @rand4Dir: () ->
        ROT.DIRS[4][Util.rand(4)]

    @millis: () ->
        new Date().getTime()

    @millisSince: (otherMillis) ->
        Util.millis() - otherMillis

    @xyDir: (dirIndex, topology = 8) ->
        ROT.DIRS[topology][dirIndex]

    @leftTurn: (xyDir) ->
        [xyDir[1], -xyDir[0]]

    @rightTurn: (xyDir) ->
        [-xyDir[1], xyDir[0]]

    @distance: (l1, l2) ->
        xDiff = l1.x - l2.x
        yDiff = l1.y - l2.y
        Math.floor Math.sqrt((xDiff * xDiff) + (yDiff * yDiff))

    @removeFromArray: (array, o) ->
        index = array.indexOf o
        if index < 0
            console.log o
            console.log array
            throw new Error("#{o} not found in array: #{array}")
        array.splice(index, 1)