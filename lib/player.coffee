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

	fire: (dirIndex) ->
		dir = ROT.DIRS[8][dirIndex]
		new Projectile(@location,dir)

	act: (e) ->
		keyMap = {}
		keyMap[13] = keyMap[32] = () => @checkBox() # enter, space
		keyMap[87] = () => @moveDir(0) # w key
		keyMap[69] = () => @moveDir(1) # e key
		keyMap[68] = () => @moveDir(2) # d key
		keyMap[67] = () => @moveDir(3) # c key
		keyMap[88] = () => @moveDir(4) # x key
		keyMap[90] = () => @moveDir(5) # z key
		keyMap[65] = () => @moveDir(6) # a key
		keyMap[81] = () => @moveDir(7) # q key


		keyMap[38] = () => @fire(0) # Up arrow
		keyMap[33] = () => @fire(1) # Page Up key
		keyMap[39] = () => @fire(2) # Right Arrow
		keyMap[34] = () => @fire(3) # Page down
		keyMap[40] = () => @fire(4) # Down Arrow
		keyMap[35] = () => @fire(5) # End key
		keyMap[37] = () => @fire(6) # Left arrow
		keyMap[36] = () => @fire(7) # Home key
	
		if @lastCode? and (@lastCode of keyMap)
			keyMap[@lastCode]()
		@lastCode = null
		window.setTimeout (=> @act()), 50 

	draw: () ->
		Game.draw @location, "@", "#ff0"

	checkBox: () ->
		if Game.map.at(@location) != "*"
			alert "There is no box here!"
		else if _.isEqual(@location, Game.prize)
			alert "Hooray! You found the gem of success and won this game."
			window.removeEventListener "keydown", this
			location.reload()
		else
			alert "This box is empty :-("