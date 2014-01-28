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
		$scence = $('#scence').parallax()

	updateScrollPos:(that, it)->
		it.controller.setScrollContainerOffset(0, -(that.y>>0)).triggerCheckAnim(true)

	buildAnimations:->
		@controller.addTween 10, TweenMax.to($('.rect-e.is-one'), .75, {css:{ y: 800, rotation: 900}}), 2000
		@controller.addTween 500, TweenMax.to($('.rect-e.is-one'), .75, {css:{ top: 300, y: 0 }}), 2000

		# i = 0
		# interval = setInterval =>
		# 	@controller.setScrollContainerOffset(0, i++)
		# 	@controller.triggerCheckAnim(true)
		# 	if i is 300 then clearInterval interval
		# , 10




new App














