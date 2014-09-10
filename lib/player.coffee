class window.Player

	constructor: (location) ->
		@location = location
		@draw()

	getSpeed: () ->
		return 100

	getLocation: () ->
		return @location

	act: ->
		Game.engine.lock()
		window.addEventListener "keydown", this

	handleEvent: (e) ->

		code = e.keyCode
		#  13=space, 32=enter
		if code is 13 or code is 32
			@checkBox()
			return
		keyMap = {}
		keyMap[38] = 0 # Up arrow
		keyMap[33] = 1 # Up key
		keyMap[39] = 2 # Right Arrow
		keyMap[34] = 3 # Page down
		keyMap[40] = 4 # Down Arrow
		keyMap[35] = 5 
		keyMap[37] = 6
		keyMap[36] = 7
	
		# one of numpad directions? 
		return  unless code of keyMap
	
		# is there a free space? 
		dir = ROT.DIRS[8][keyMap[code]]
		nextLocation = Util.addDir(@location, dir)
		return  unless Game.map.isOpen(nextLocation)
		Game.drawMapLocation @location
		@location = nextLocation
		@draw()
		window.removeEventListener "keydown", this
		Game.engine.unlock()

	draw: () ->
		Game.draw @location, "@", "#ff0"

	checkBox: () ->
		unless Game.map.at(@location) is "*"
			console.log "There is no box here!"
		else if @location is Game.ananas
			console.log "Hooray! You found the gem of success and won this game."
			Game.engine.lock()
			window.removeEventListener "keydown", this
		else
			console.log "This box is empty :-("