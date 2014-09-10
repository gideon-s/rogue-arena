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

	moveDir: (dirIndex) ->
		dir = ROT.DIRS[8][dirIndex]
		nextLocation = Util.addDir(@location, dir)
		return  unless Game.map.isOpen(nextLocation)
		Game.drawMapLocation @location
		@location = nextLocation
		@draw()

	handleEvent: (e) ->
		keyMap = {}
		keyMap[13] = keyMap[32] = () => @checkBox()
		keyMap[38] = () => @moveDir(0) # Up arrow
		keyMap[33] = () => @moveDir(1) # Up key
		keyMap[39] = () => @moveDir(2) # Right Arrow
		keyMap[34] = () => @moveDir(3) # Page down
		keyMap[40] = () => @moveDir(4) # Down Arrow
		keyMap[35] = () => @moveDir(5) 
		keyMap[37] = () => @moveDir(6)
		keyMap[36] = () => @moveDir(7)
	
		# one of numpad directions? 
		code = e.keyCode
		return unless code of keyMap
		keyMap[code]()
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