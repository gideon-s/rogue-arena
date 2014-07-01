test "Random Returns number between 0 and 9", ()  ->
	for index in [1..200]
		number = Util.rand(10)
		console.log "number: #{number}"
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
		console.log "picked thing: #{thing}"
		result[thing] ||= 0
		result[thing] += 1	
	for t in listOfThings
        console.log t
		ok result[t], "failed to find #{t}"

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
	console.log coordList
	for index in [1..200]
		console.log index
		[x, y] = Coordinates.selectRandom(coordList)
		console.log "coords picked: #{x} #{y}"
		coords = Coordinates.create(x, y)
		result[coords] ||= 0
		result[coords] += 1
		console.log result
	for c in coordList
		console.log c
		ok result[c], "failed to find #{c}"
	