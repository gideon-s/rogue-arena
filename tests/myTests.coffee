test "Random Returns number between 0 and 9", ()  ->
	for index in [1..200]
		number = Util.rand(10)
		actual = if number <= 10 and number >= 0 then true else false
		equal actual, true

test "Random Returns integer", () ->
	for index in [1..100]
		number = Util.rand(50)
		actual = if parseFloat(number) is parseInt(number) then true else false
		equal actual, true


test "pickRandom Returns items from list", ()  ->
	listOfThings = ['head','right arm','left arm','chest','groin','right leg', 'left leg']
	result = {}
	for index in [1..100]
		thing = Util.pickRandom(listOfThings)
		result[thing] ||= 0
		result[thing] += 1	
	for t in listOfThings
		ok result[t], "failed to find #{t}"

test "coordinates at 0,0 aren't weird", () ->
	deepEqual [0,0], Coordinates.parse("0,0")
	equal "0,0", Coordinates.create(0,0)

test "coordinates create/parse",() ->
	deepEqual [1,1], Coordinates.parse("1,1")

test "Coordinate Parse returns x=10 y=20", () ->
	key = '10,20'
	[x, y] = Coordinates.parse(key)
	actual = if x is 10 and y is 20 then true else false
	equal actual, true

test "Coordinate Create returns 10,20", () ->
	x = 10
	y = 20
	keyVal = Coordinates.create(x, y)
	actual = if keyVal is "10,20" then true else false
	equal actual, true


test "Coordinate selectRandom returns values from list of coordinates", () ->
	coordList = ["1,1","1,2","1,3","1,4","1,5","1,6","1,7","1,8","1,9","1,10","2,1","2,2","2,3","2,4","2,5","2,6","2,7","2,8","2,9","2,10"]
	result = {}
	for index in [1..200]
		[x, y] = Coordinates.selectRandom(coordList)
		coords = Coordinates.create(x, y)
		result[coords] ||= 0
		result[coords] += 1
	for c in coordList
		ok result[c], "failed to find #{c}"

test "Map 1 and Map 2 should contain different characters at 0,0", () ->
    map1 = new Map()
    map2 = new Map()
    map1.setSquare([0,0], "@")
    equal "@", map1.at([0,0])
    map2.setSquare([0,0], "$")
    equal "$", map2.at([0,0])
    notEqual map1.at([0,0]), map2.at([0,0])

test "locations of map should return list of x,y pairs", () ->
	map = new Map()
	deepEqual [], map.locationKeys()
	map.setSquare([0,0], "X")
	deepEqual ["0,0"], map.locationKeys()
	console.log map.locationKeys()

	map.setSquare([0,1], ".")
	console.log map.locationKeys()
	deepEqual ["0,0", "0,1"], map.locationKeys()


