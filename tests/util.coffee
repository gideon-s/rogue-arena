class window.Util
	@rand: (highNumber) -> 
		return Math.floor(ROT.RNG.getUniform() * highNumber)

	@pickRandom: (list) -> 
		list[@rand(list.length)]

	@addDir: (location, dir) ->
		[location[0]+dir[0],location[1]+dir[1]]
