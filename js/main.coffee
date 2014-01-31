class App 
	constructor:->
		@vars()

		@initScroll()
		@initController()
		@buildAnimations()
		@initParallax()

	vars:->
		@$main =  $('#js-main')
		@$body = 	$(document.body)
		@scrollPos = 0
		@$window = $(window)
		@$window.height()
		@frameDurationTime = 2500
		@$mainLogo 	= @$('#js-main-logo')
		@$script1 	= @$('#js-script1')
		@$script2 	= @$('#js-script2')
		@$scence  	= @$('#js-curtain1')
		@$scence2 	= @$('#js-curtain2')

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
		@$scence.parallax()
		@$scence2.parallax()

	updateScrollPos:(that, it)->
		# STOP ANIMATION ON SCROLL

		# clearTimeout it.timer
		# it.timer = setTimeout (-> it.$body.removeClass('stop-animation'); it.isStopAnimationClass = false ), 200
		
		# if !it.isStopAnimationClass 
		# 	it.$body.addClass 'stop-animation'
		# 	it.isStopAnimationClass = true
		# console.log that.y>>0
		it.controller.setScrollContainerOffset(0, -(that.y>>0)).triggerCheckAnim(true)


	buildAnimations:->
		# THE FIRST CURTAIN
		@curtainTween1 	= TweenMax.to @$('.curtain-l'), .75, { css:{ top: '-100%' }, onUpdate: StatSocial.helpers.bind(@onCurtain1Update,@) }
		@curtainTween2 	= TweenMax.to @$('.curtain2-l'), .75, { css:{ top: '-22px', y: 0 } }
		@scriptTween1  	= TweenMax.to @$script1, .75, { css:	{ top: '50%', opacity: 1 } }
		@scriptTween12  = TweenMax.to @$script1, .75, { css:	{ top: '95%' } }
		@logoTween  		= TweenMax.to @$mainLogo, .75, { css:	{ top: '100%'} }

		# FIX
		@$mainLogo.css 'top': '50%'
		
		@controller.addTween @frameDurationTime, @curtainTween1, @frameDurationTime
		@controller.addTween @frameDurationTime, @curtainTween2, @frameDurationTime
		@controller.addTween 1, @scriptTween1, @frameDurationTime/1.5
		@controller.addTween @frameDurationTime, @scriptTween12, @frameDurationTime/2
		@controller.addTween @frameDurationTime, @logoTween, @frameDurationTime/2

		
		@scriptTween2  = TweenMax.to @$script2, .75, { css:{ top: '50%' } }
		@controller.addTween @frameDurationTime, @scriptTween2, @frameDurationTime*1.5


		$images = @$scence.find('.curtain-layer-lh')
		for el, i in $images
			$el = $ el
			@controller.addTween @frameDurationTime, TweenMax.to($el, .75, { css:{ top: "#{(50+(i*5))}%" } }), @frameDurationTime


		# THE SECOND CURTAIN
		@$left 		= @$('#js-curtain2-left-side')
		@$right 		= @$('#js-curtain2-right-side')
		$leftEls 	= @$left.find('.curtain2-section-lh')
		$rightEls = @$right.find('.curtain2-section-lh')

		start = 2*@frameDurationTime
		rotateDegree = 5
		rotateElsCountLeft = Math.min $leftEls.length, 10
		for i in [$leftEls.length..$leftEls.length-rotateElsCountLeft]
			$el = $ $leftEls.eq i
			@controller.addTween start-(i*(@frameDurationTime/$leftEls.length)), TweenMax.to($el, .75, { css:{ rotation: rotateDegree, transformOrigin: 'left top' } }), @frameDurationTime

		for el, i in $rightEls
			$el = $ el
			@controller.addTween start-(($rightEls.length-i)*(@frameDurationTime/$rightEls.length)), TweenMax.to($el, .75, { css:{ rotation: -rotateDegree, transformOrigin: 'right top' } }), @frameDurationTime
		
		@curtain2LeftTween = TweenMax.to(@$left, .75, { css:{ left: -@$window.outerWidth()/2 }, onUpdate: StatSocial.helpers.bind(@onCurtain2Update,@)  })
		
		@controller.addTween start, @curtain2LeftTween, @frameDurationTime
		@controller.addTween start, TweenMax.to(@$right, .75, { css:{ left: (@$window.outerWidth()/2) + $rightEls.first().outerWidth() } }), @frameDurationTime

		# THE THIRD CURTAIN
		start = 3.5*@frameDurationTime
		@groundTween  = TweenMax.to @$('#js-ground'), .75, { css:{ left: '0' } }
		@controller.addTween start, @groundTween, @frameDurationTime



	$:(selector)->
		@$main.find(selector)

	onCurtain1Update:->
		if @curtainTween1.totalProgress() >= 1
			@isFirstCurtainParallax and @$scence.parallax 'disable'
			@isFirstCurtainParallax = false
			@$scence.hide()
		else
			!@isFirstCurtainParallax and @$scence.parallax 'enable'
			@isFirstCurtainParallax = true
			@$scence.show()

	onCurtain2Update:->
		console.log @curtain2LeftTween.totalProgress()
		# if @$left.totalProgress() >= 1
		# 	@isFirstCurtainParallax and @$scence.parallax 'disable'
		# 	@isFirstCurtainParallax = false
		# 	@$scence.hide()
		# else
		# 	!@isFirstCurtainParallax and @$scence.parallax 'enable'
		# 	@isFirstCurtainParallax = true
		# 	@$scence.show()




new App














