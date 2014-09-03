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
    map1 = new Map(3,3)
    map2 = new Map(3,3)
    map1.setLocation([0,0], "@")
    equal "@", map1.at([0,0])
    map2.setLocation([0,0], "$")
    equal "$", map2.at([0,0])
    notEqual map1.at([0,0]), map2.at([0,0])

test "locations of map should return list of x,y pairs", () ->
	map = new Map(5,5)
	map.setLocation([0,0], "X")
	deepEqual [[0,0]], map.locations()
	map.setLocation([0,1], ".")
	deepEqual [[0,0],[0,1]], map.locations()

test "Is open map area", () ->
	map = new Map(10,10)
	map.setLocation([2,3],".")
	ok map.isOpen([2,3])
	ok !map.isOpen([2,4])

test "map.randomLocation returns realistic value spread", () ->
	map = new Map(10,10)
	for i in [0...10]
		map.setLocation([0,i],"0")
	for i in [0...100]
		[x,y] = map.randomLocation()
		val = map.at([x,y]) 
		val++
		map.setLocation([x,y], val)
		actual = true
	for location in map.locations()
		if map.at(location) > 18 || map.at(location) < 3
			actual = false
	equal actual, true


