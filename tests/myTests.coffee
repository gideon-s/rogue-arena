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

test "location(0,1) returns x=0 and y=1", () ->
	location = new Location [0,1]
	equal location.x,0 
	equal location.y,1
	location = location.addDir [1,1]
	equal location.x,1
	equal location.y,2




