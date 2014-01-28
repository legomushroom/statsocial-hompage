class App 
	constructor:->
		@vars()

		@initScroll()

	vars:->
		@$main =  $('#js-main')

	initScroll:->
		console.log @$main[0]