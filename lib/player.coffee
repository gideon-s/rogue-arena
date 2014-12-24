class window.Player extends window.Actor

	constructor: (location) ->
		super(Game, location, "@", "white", 50)
		@score = 0
		@shotsFired = 0
		window.addEventListener "keydown", this

	getLocation: () -> @location

	handleEvent: (e) ->
		@lastCode = e.keyCode

	moveDir: (dirIndex) ->
		dir = ROT.DIRS[8][dirIndex]
		nextLocation = @location.addDir(dir)
		return  unless Game.map.isOpen(nextLocation)
		@location = nextLocation

	fire: (dirIndex) ->
		dir = ROT.DIRS[8][dirIndex]
		nextLocation = @location.addDir(dir)
		new Projectile(nextLocation,dir)
		@shotsFired++

	addScore: () ->
		@score++

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

		keyMap[89] = () => @fire(0) # y key
		keyMap[85] = () => @fire(1) # u key
		keyMap[74] = () => @fire(2) # j key
		keyMap[77] = () => @fire(3) # m key
		keyMap[78] = () => @fire(4) # n key
		keyMap[66] = () => @fire(5) # b key
		keyMap[71] = () => @fire(6) # g key
		keyMap[84] = () => @fire(7) # t key


		keyMap[38] = () => @fire(0) # Up arrow
		keyMap[33] = () => @fire(1) # Page Up key
		keyMap[39] = () => @fire(2) # Right Arrow
		keyMap[34] = () => @fire(3) # Page down
		keyMap[40] = () => @fire(4) # Down Arrow
		keyMap[35] = () => @fire(5) # End key
		keyMap[37] = () => @fire(6) # Left arrow
		keyMap[36] = () => @fire(7) # Home key

		keyMap[27] = () => location.reload()
	
		if @lastCode? and (@lastCode of keyMap)
			keyMap[@lastCode]()
		@lastCode = null

	checkBox: () ->
		if Game.map.at(@location) != "*"
			alert "There is no box here!"
		else if _.isEqual(@location, Game.prize)
			alert "Hooray! You found the gem of success and won this game."
			window.removeEventListener "keydown", this
			location.reload()
		else
			alert "This box is empty :-("