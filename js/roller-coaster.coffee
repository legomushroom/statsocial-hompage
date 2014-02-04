class Roller
	endPoints1: []
	endPoints2: []
	constructor:(@o={})->
		@vars()
		@showAxes()

	vars:->
		@$rollerLine1 = $('#roller-line1')
		@$rollerLine2 = $('#roller-line2')

		@$x = $('#roller-x')
		@$y = $('#roller-y')

	showAxes:->
		yEnd = parseInt @$y.attr('transform').split(',')[1], 10


new Roller