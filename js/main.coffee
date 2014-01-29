class App 
	constructor:->
		@vars()

		@initScroll()
		@initController()
		@buildAnimations()
		@initParallax()

	vars:->
		@$main =  $('#js-main')
		@scrollPos = 0

	initController:->
		@controller = $.superscrollorama
											triggerAtCenter: false
											playoutAnimations: true

	initScroll:->
		@scroller = new IScroll '#js-main', { probeType: 3, mouseWheel: true }
		document.addEventListener 'touchmove', ((e)-> e.preventDefault()), false

		it = @
		@scroller.on 'scroll',  	-> it.updateScrollPos this, it
		@scroller.on 'scrollEnd', -> it.updateScrollPos this, it

	initParallax:->
		$scence = $('#js-main').parallax()

	updateScrollPos:(that, it)->
		it.controller.setScrollContainerOffset(0, -(that.y>>0)).triggerCheckAnim(true)

	buildAnimations:->
		@controller.addTween 1, TweenMax.to($('.curtain-l'), .75, {css:{ y: '-1000%' }}), 3000

new App














