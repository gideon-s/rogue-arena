class window.Util
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