test "location constructor does not accept invalid values", () ->
	throws (-> new Location("X")), "asdf"
	throws (-> new Location([1,2,3])), "three ints"
	throws (-> new Location(["one","two"])), "two strings"
	throws (-> new Location(["X","Y"])), "array of char"

test "map 'on' does not accept an invalid argument", () ->
	location1 = new Location([1,1])
	map = "This is a string"
	throws (-> location1.on(map)), "map is bad"


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
	map = new Map(1,2)
	location = new Location [0,0]
	location2 = new Location [0,1]
	deepEqual [location,location2], map.locations()

test "Is open map area", () ->
	map = new Map(3,3)
	location = new Location [0,1]
	location2 = new Location [2,3] 
	ok map.isOpen(location)
	ok !map.isOpen(location2)

test "map.randomLocation returns realistic value spread", () ->
	map = new Map(1,10)
	for location in map.locations()
		map.setLocation(location,"0")
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
	map = new Map(10,10)
	location = new Location [2,1]
	destLocation = new Location [2,4]
	path = location.pathToDestination(destLocation,map)
	nextStep = location.nextStepToDestination(destLocation,map)
	deepEqual path,[new Location([2,2]),new Location([2,3]),new Location([2,4])]
	deepEqual nextStep,new Location [2,2]

mockGame = 
	player: false
	actors: []
	map: new Map(5,5)
	drawMapLocation: (loc) -> #no op
	gameOver: () -> #no op
	enters: () -> #no op
	draw: () -> #no op
	nextAction: () -> #no op

test "actor is not dead", () ->
	location = new Location [1,1]
	mockGame.map.setLocation location," "
	actor = new Actor(mockGame, location,"Y","blue",50)
	equal actor.dead,false

test "actor struckBy another actor kills both", () ->
	location1 = new Location [0,0]
	location2 = new Location [0,1]
	mockGame.map.setLocation location1," "
	mockGame.map.setLocation location2," "
	actor = new Actor(mockGame, location1, "Y", "blue", 50)
	actor2 = new Actor(mockGame, location2, "X","red",50)
	equal actor.dead,false
	actor.struckBy(actor2)
	equal actor.dead,true
	equal actor2.dead,true

test "edgeLocations contain map edge coordinates", () ->
	map = new Map(2,2)
	deepEqual map.edgeLocations(), [new Location([0,0]),new Location([0,1]),new Location([1,0]),new Location([1,1])]

test "In map.on, return false if location is undefined", () ->
	map = new Map(3,2)
	equal map.isOpen(new Location([-1,-1])), false
	equal map.isOpen(new Location([0,2])), false
	equal map.isOpen(new Location([0,-1])), false
	equal map.isOpen(new Location([1,2])), false
	equal map.isOpen(new Location([4,3])), false

#test "If an Enemy's neighbor square contains another Enemy, stay put", () ->
#	map = new Map(3,3)
#	location1 = new Location [1,1]
#	location2 = new Location [2,2]
#	enemy1 = new Enemy(mockGame, location1)
#	enemy2 = new Enemy(mockGame, location2)
	