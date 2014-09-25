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

test "Map 1 and Map 2 should contain different characters at 0,0", () ->
    map1 = new Map(3,3)
    map2 = new Map(3,3)
    location = new Location [0,0]
    map1.setLocation(location,"@")
    equal "@", map1.at(location)
    map2.setLocation(location, "$")
    equal "$", map2.at(location)
    notEqual map1.at(location), map2.at(location)

test "locations of map should return list of x,y pairs", () ->
	map = new Map(5,5)
	location = new Location [0,0]
	map.setLocation(location, "X")
	deepEqual [location], map.locations()
	location2 = new Location [0,1]
	map.setLocation(location2, ".")
	deepEqual [location,location2], map.locations()

test "Is open map area", () ->
	map = new Map(10,10)
	location = new Location [2,3]
	map.setLocation(location,".")
	ok map.isOpen(location)
	ok !map.isOpen(new Location [0,0])

test "map.randomLocation returns realistic value spread", () ->
	map = new Map(10,10)
	for i in [0...10]
		map.setLocation(new Location([0,i]),"0")
	for i in [0...100]
		location = map.randomLocation()
		val = map.at(location) 
		val++
		map.setLocation(location, val)
		actual = true
	for location in map.locations()
		if map.at(location) > 18 || map.at(location) < 3
			actual = false
	equal actual, true

test "location(0,1) returns x=0 and y=1", () ->
	location = new Location [0,1]
	equal location.x,0 
	equal location.y,1
	location = location.addDir [1,1]
	equal location.x,1
	equal location.y,2

test "path contains expected path to destination, nextStep contains the first location in the path", () ->
	map = new Map(5,5)
	for i in [1...4]
		map.setLocation(new Location([1,i]), ".")
	location = new Location [1,1]
	destLocation = new Location [1,4]
	path = location.pathToDestination(destLocation,map)
	nextStep = location.nextStepToDestination(destLocation,map)
	deepEqual path,[new Location([1,2]),new Location([1,3]),new Location([1,4])]
	deepEqual nextStep,new Location [1,2]


	


