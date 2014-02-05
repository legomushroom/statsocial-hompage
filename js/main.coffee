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
		@$scence3 	= @$('#js-curtain3')
		@$plane 		= @$('#js-plane')
		@prevPlaneProgress = -1

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
		@groundTween  = TweenMax.to @$('#js-ground'), .75, { css:{ x: 0 } }
		@controller.addTween start, @groundTween, @frameDurationTime

		@bgTween  = TweenMax.to @$('#js-bg'), .75, { css:{ opacity: 1 } }
		@controller.addTween start, @bgTween, @frameDurationTime

		$clouds = @$('.cloud-b')
		@cloudTween = TweenMax.to $clouds, .75, { onComplete: (=> $clouds.addClass('is-anima')), onReverseComplete:(=> $clouds.removeClass('is-anima')) }
		@controller.addTween start, @cloudTween, 1

		# -> BUILDINGS
		start = 6*@frameDurationTime
		$buildings  = @$('.building-b')
		for i in [0..$buildings.length]
			$el = $ $buildings.eq i
			@controller.addTween start-(($buildings.length-i)*(@frameDurationTime/$buildings.length)), TweenMax.to($el, .75, { css:{ y: 0, bottom: 145 } }), @frameDurationTime

		@scriptTween3  = TweenMax.to @$script2, .75, { css:{ top: '-10%' }, onUpdate: StatSocial.helpers.bind(@onCurtain2UpdateEnd,@) }
		@controller.addTween start-(@frameDurationTime/10), @scriptTween3, @frameDurationTime*1.5

		# -> PLANE
		start = 8*@frameDurationTime
		@$plane = @$('#js-plane')
		@$planeInner = @$plane.find('#js-plane-inner')
		@planeTween  = TweenMax.to @$plane, .75, { css:{ left: '-100%' }, onUpdate: StatSocial.helpers.bind(@onPlaneUpdate,@) }
		@controller.addTween start, @planeTween, @frameDurationTime*6


		# -> BUSHES
		start = 10*@frameDurationTime
		@bushTween = TweenMax.to $clouds, .75, { onComplete: (=> @$scence3.addClass('is-show-bushes')), onReverseComplete:(=> @$scence3.removeClass('is-show-bushes')) }
		@controller.addTween start, @bushTween, 1

		# -> ROLLER-COASTER
		start = 13*@frameDurationTime
		@$yAxes = @$('#js-roller-y')
		@$xAxes = @$('#js-roller-x')
		
		@$rollerLine1 = @$('#js-roller-line1')
		@$rollerLine2 = @$('#js-roller-line2')
		@rollerLine2  = @$rollerLine2[0]
		@$rollerLineBg2 = @$('#js-roller-line-bg2')
		@$rollerLineBg1 = @$('#js-roller-line-bg1')
		@$rollerCabin1 	= @$('#js-roller-cabin1') 

		@$rollerText 		= @$('#js-roller-text')
		@rollerText 		= @$rollerText[0]
		@rollerTextOffset = parseInt @rollerText.getAttribute('startOffset'), 10
		
		@rollerAxesTween = TweenMax.to {}, .75, { onUpdate: StatSocial.helpers.bind(@onRollerAxesUpdate,@) }
		@controller.addTween start, @rollerAxesTween, @frameDurationTime

		start = 14*@frameDurationTime
		# --> ROLLER-COASTER BUILD
		@rollerRailsTween1 = TweenMax.to { y: 400 }, .75, { y: 0, onUpdate: StatSocial.helpers.bind(@onRollerRails1Update,@) }
		@controller.addTween start, @rollerRailsTween1, @frameDurationTime

		@rollerRailsTween2 = TweenMax.to { y: 400 }, 1, { y: 0, onUpdate: StatSocial.helpers.bind(@onRollerRails2Update,@) }
		@controller.addTween start, @rollerRailsTween2, 2*@frameDurationTime

		start = 16*@frameDurationTime
		@rollerTextTween = TweenMax.to { offset: @rollerTextOffset }, 1, { offset: @rollerLine2.getTotalLength(), onUpdate: StatSocial.helpers.bind(@onRollerTextUpdate,@) }
		@controller.addTween start, @rollerTextTween, 6*@frameDurationTime

	onRollerTextUpdate:->
		progress = @rollerTextTween.totalProgress()
		pathProgress = @rollerTextTween.target.offset-@rollerTextOffset
		point  		= @rollerLine2.getPointAtLength pathProgress
		prevPoint = @rollerLine2.getPointAtLength pathProgress - 25

		cathetus   = Math.abs point.x-prevPoint.x
		hypotenuse = Math.abs Math.sqrt Math.pow(point.x-prevPoint.x,2)+Math.pow(point.y-prevPoint.y,2)
		console.log point.y-prevPoint.y

		degree = Math.acos(cathetus/hypotenuse)*(180/Math.PI)
		# console.log degree
		@rollerText.setAttribute('startOffset', "#{@rollerTextTween.target.offset}")
		@$rollerCabin1.parent()
									.attr('transform', "translate(#{point.x}, #{point.y-50}) rotate(#{degree}, 21, 21)")

		# for point in points1
	onRollerRails1Update:()-> 
		@$rollerLine1.attr( 	'transform', "translate(0,#{@rollerRailsTween1.target.y})")
		@$rollerLineBg1.attr( 'transform', "translate(0,#{@rollerRailsTween1.target.y})")

	onRollerRails2Update:()-> 
		@$rollerLine2.attr('transform', "translate(0,#{@rollerRailsTween2.target.y})")
		@$rollerLineBg2.attr('transform', "translate(0,#{@rollerRailsTween2.target.y})")

	onRollerAxesUpdate:()->
		progress = @rollerAxesTween.totalProgress()
		@$yAxes.attr('transform', "translate(0,#{520-(520*progress)})")
		@$xAxes.attr('transform', "translate(#{-1240+(1240*progress)},0)")

	onPlaneUpdate:->
		progress = @planeTween.totalProgress()

		if @prevPlaneProgress > progress
			!@isPlaneFlip and @$planeInner.addClass 'is-flip'
			@isPlaneFlip = true
		else
			@isPlaneFlip and @$planeInner.removeClass 'is-flip'
			@isPlaneFlip = false

		@prevPlaneProgress = progress

		if progress > 0 and progress < 1
			!@isBuildingCategories and @$scence3.addClass 'show-building-categories-gt'
			@isBuildingCategories = true
		else 
			@isBuildingCategories and @$scence3.removeClass 'show-building-categories-gt'
			@isBuildingCategories = false
		
		if progress >= 1
			!@isPlaneHide and @$plane.hide()
			@isPlaneHide = 	true
		else 
			@isPlaneHide and @$plane.show()
			@isPlaneHide = 	false



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
		if @curtain2LeftTween.totalProgress() >= 1
			@isSecondCurtainParallax and @$scence2.parallax 'disable'
			@isSecondCurtainParallax = false
			@$left.hide()
			@$right.hide()
		else
			!@isSecondCurtainParallax and @$scence2.parallax 'enable'
			@isSecondCurtainParallax = true
			@$left.show()
			@$right.show()

	onCurtain2UpdateEnd:->
		if @scriptTween3.totalProgress() >= 1
			@$scence2.hide()
		else @$scence2.show()





new App














