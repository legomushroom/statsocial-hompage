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
		@$scence = @$('#js-curtain1').parallax()

	updateScrollPos:(that, it)->
		it.controller.setScrollContainerOffset(0, -(that.y>>0)).triggerCheckAnim(true)

	buildAnimations:->
		@curtainTween1 = TweenMax.to @$('.curtain-l'), .75, { css:{ top: '-100%', y: -20 }, onUpdate: StatSocial.helpers.bind(@onUpdate,@) }
		@curtainTween2 = TweenMax.to @$('.curtain2-l'), .75, { css:{ top: '0', y: 0 } }

		@controller.addTween 1, @curtainTween1, 2500
		@controller.addTween 1, @curtainTween2, 2500

	$:(selector)->
		@$main.find(selector)

	onUpdate:->
		if @curtainTween1.totalProgress() >= 1
			@isFirstCurtainParallax and @$scence.parallax 'disable'
			@isFirstCurtainParallax = false
			@$scence.hide()
		else
			!@isFirstCurtainParallax and @$scence.parallax 'enable'
			@isFirstCurtainParallax = true
			@$scence.show()




new App














