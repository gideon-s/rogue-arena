class window.Timer
	constructor: () ->

	nextAction: (@speed, @action) ->
		window.setTimeout (=> @action()), @speed
