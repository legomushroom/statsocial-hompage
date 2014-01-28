class App 
	constructor:->
		@vars()

		@initScroll()

	vars:->
		@$main =  $('#js-main')
		@scrollPos = 0

	initScroll:->
		console.log @$main[0]
		@scroller = new IScroll '#js-main', { probeType: 3, mouseWheel: true }
		document.addEventListener 'touchmove', ((e)-> e.preventDefault()), false

		@scroller.on 'scroll',  	@updateScrollPos
		@scroller.on 'scrollEnd', @updateScrollPos

	updateScrollPos:->
		console.log @y>>0




new App














