class window.Player

	constructor: (location) ->
		@location = location
		@draw()
		window.setTimeout (=> @act()), 2000 
		window.addEventListener "keydown", this

	getSpeed: () -> 100
	getLocation: () -> @location

	handleEvent: (e) ->
		@lastCode = e.keyCode

	moveDir: (dirIndex) ->
		dir = ROT.DIRS[8][dirIndex]
		nextLocation = @location.addDir(dir)
		return  unless Game.map.isOpen(nextLocation)
		Game.drawMapLocation @location
		@location = nextLocation
		@draw()

	act: (e) ->
		keyMap = {}
		keyMap[13] = keyMap[32] = () => @checkBox() # enter, space
		keyMap[38] = () => @moveDir(0) # Up arrow
		keyMap[33] = () => @moveDir(1) # Page Up key
		keyMap[39] = () => @moveDir(2) # Right Arrow
		keyMap[34] = () => @moveDir(3) # Page down
		keyMap[40] = () => @moveDir(4) # Down Arrow
		keyMap[35] = () => @moveDir(5) # End key
		keyMap[37] = () => @moveDir(6) # Left arrow
		keyMap[36] = () => @moveDir(7) # Home key
	
		if @lastCode? and (@lastCode of keyMap)
			keyMap[@lastCode]()
			#window.removeEventListener "keydown", this
			#Game.engine.unlock()
		@lastCode = null
		window.setTimeout (=> @act()), 2000 

	draw: () ->
		Game.draw @location, "@", "#ff0"

	checkBox: () ->
		if Game.map.at(@location) != "*"
			alert "There is no box here!"
		else if _.isEqual(@location, Game.prize)
			alert "Hooray! You found the gem of success and won this game."
			#Game.engine.lock()
			window.removeEventListener "keydown", this
		else
			alert "This box is empty :-("