class window.Player extends window.Actor

	constructor: (location) ->
		super(Game, location, "@", "white", 50)
		@score = 0
		@shotsFired = 0
		window.addEventListener "keydown", this

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
		Game.drawScore()

	act: (e) ->
		keyMap = {}
		#keyMap[13] = keyMap[32] = () => @checkBox() # enter, space
		keyMap[ROT.VK_W] = () => @moveDir(0) 
		keyMap[ROT.VK_D] = () => @moveDir(2)
		keyMap[ROT.VK_S] = () => @moveDir(4) 
		keyMap[ROT.VK_A] = () => @moveDir(6)

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

	
