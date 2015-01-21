class window.Util
	@rand: (highNumber) -> 
		return Math.floor(ROT.RNG.getUniform() * highNumber)

	@pickRandom: (list) -> 
		list[@rand(list.length)]

	@oneIn: (number) ->
		Util.rand(number) == 0 
	