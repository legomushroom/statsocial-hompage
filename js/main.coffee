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
		@curtainTween1 = TweenMax.to @$('.curtain-l'), .75, { css:{ top: '-100%' }, onUpdate: StatSocial.helpers.bind(@onUpdate,@) }
		@curtainTween2 = TweenMax.to @$('.curtain2-l'), .75, { css:{ top: '-22px', y: 0 } }

		@controller.addTween 1, @curtainTween1, 2500
		@controller.addTween 1, @curtainTween2, 2500


		$left 		= @$('#js-curtain2-left-side')
		$right 		= @$('#js-curtain2-right-side')
		$leftEls 	= $left.find('.curtain2-section-lh')
		$rightEls = $right.find('.curtain2-section-lh')

		start = 8000
		rotateDegree = 5
		rotateElsCountLeft = Math.min $leftEls.length, 10
		for i in [$leftEls.length..$leftEls.length-rotateElsCountLeft]
			$el = $ $leftEls.eq i
			@controller.addTween start-(i*300), TweenMax.to($el, .75, { css:{ rotation: rotateDegree, transformOrigin: 'left top' } }), 2500

		for el, i in $rightEls
			$el = $ el
			@controller.addTween start-(($rightEls.length-i)*300), TweenMax.to($el, .75, { css:{ rotation: -rotateDegree, transformOrigin: 'right top' } }), 2500
		
		@controller.addTween start/2, TweenMax.to($left, .75, { css:{ left: '-100%' } }), 20000
		@controller.addTween start/2, TweenMax.to($right, .75, { css:{ left: '100%' } }), 20000


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














