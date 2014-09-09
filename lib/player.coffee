class window.Player

	constructor: (x,y) ->
		@_x = x
		@_y = y
		@draw()

	getSpeed: () ->
		return 100

	getX: () ->
		return @_x

	getY: () ->
		return @_y


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
		# Up arrow
		keyMap[38] = 0
		# Up key
		keyMap[33] = 1
		# Right Arrow
		keyMap[39] = 2
		# Page down
		keyMap[34] = 3
		# Down Arrow
		keyMap[40] = 4
		keyMap[35] = 5
		keyMap[37] = 6
		keyMap[36] = 7
	
		# one of numpad directions? 
		return  unless code of keyMap
	
		# is there a free space? 
		dir = ROT.DIRS[8][keyMap[code]]
		newX = @_x + dir[0]
		newY = @_y + dir[1]
		return  unless Game.map.isOpen([newX,newY])
		Game.display.draw @_x, @_y, Game.map.at([@_x , @_y])
		@_x = newX
		@_y = newY
		@draw()
		window.removeEventListener "keydown", this
		Game.engine.unlock()

	draw: () ->
		Game.display.draw @_x, @_y, "@", "#ff0"

	checkBox: () ->
		playerLocation = [@_x,@_y]
		unless Game.map.at(playerLocation) is "*"
			console.log "There is no box here!"
		else if playerLocation is Game.ananas
			console.log "Hooray! You found the gem of success and won this game."
			Game.engine.lock()
			window.removeEventListener "keydown", this
		else
			console.log "This box is empty :-("