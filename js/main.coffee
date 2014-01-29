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
		@$scence = @$main.parallax()

	updateScrollPos:(that, it)->
		it.controller.setScrollContainerOffset(0, -(that.y>>0)).triggerCheckAnim(true)

	buildAnimations:->
		@curtainTween1 = TweenMax.to @$('.curtain-l'), .75, { css:{ top: '-100%' }, onUpdate: StatSocial.helpers.bind(@onUpdate,@) }

		@controller.addTween 1, @curtainTween1, 3000

	$:(selector)->
		@$main.find(selector)

	onUpdate:->
		if @curtainTween1.totalProgress() >= 1
			@isFirstCurtainParallax and @$scence.parallax 'disable'
			@isFirstCurtainParallax = false
		else
			!@isFirstCurtainParallax and @$scence.parallax 'enable'
			@isFirstCurtainParallax = true




new App














