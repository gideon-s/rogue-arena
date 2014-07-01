class window.Util
	@rand: (highNumber) -> 
		return Math.floor(ROT.RNG.getUniform() * highNumber)

	@pickRandom: (list) -> 
		list[@rand(list.length)]

class window.Coordinates
	@parse: (keyValue) ->
		parts = keyValue.split(",")
		x = parseInt(parts[0])
		y = parseInt(parts[1])
		return [x, y]

	@create: (xValue, yValue) ->
		keyValue = xValue + ',' + yValue
		return keyValue

	@selectRandom: (coordinateList) ->
		item = Util.pickRandom(coordinateList)
		[x, y] = @parse(item)
		return [x,y]