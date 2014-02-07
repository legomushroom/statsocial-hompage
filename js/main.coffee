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
		@frameDurationTime = 2000


		# THE FIRST CURTAIN
		@curtainTween1 	= TweenMax.to @$('.curtain-l'), .75,  { css:{ top: '-100%' }, onUpdate: StatSocial.helpers.bind(@onCurtain1Update,@) }
		@curtainTween2 	= TweenMax.to @$('.curtain2-l'), .75, { css:{ top: '-22px', y: 0 } }
		@scriptTween1  	= TweenMax.to @$script1, .75, { css:	{ bottom: 40, opacity: 1 } }
		
		# @scriptTween12  = TweenMax.to @$script1, .75, { css:	{ top: '95%' } }
		# @logoTween  		= TweenMax.to @$mainLogo, .75, { css:	{ top: '100%'} }

		# FIX
		# @$mainLogo.css 'top': '50%'
		
		@controller.addTween 1, @scriptTween1, @frameDurationTime/2

		start = @frameDurationTime
		@controller.addTween start, @curtainTween1, @frameDurationTime
		@controller.addTween start, @curtainTween2, @frameDurationTime
		# @controller.addTween start, @scriptTween12, @frameDurationTime/2
		# @controller.addTween start, @logoTween,  		@frameDurationTime/2

		$images = @$scence.find('.curtain-layer-lh')
		for el, i in $images
			$el = $ el
			@controller.addTween @frameDurationTime, TweenMax.to($el, .75, { css:{ top: "#{(50+(i*5))}%" } }), @frameDurationTime

		# THE SECOND CURTAIN
		@$left 		= @$('#js-curtain2-left-side')
		@$right 		= @$('#js-curtain2-right-side')
		# $leftEls 	= @$left.find('.curtain2-section-lh')
		$rightEls = @$right.find('.curtain2-section-lh')

		# start = 3*@frameDurationTime
		# rotateDegree = 5
		# rotateElsCountLeft = Math.min $leftEls.length, 10
		# for i in [$leftEls.length..$leftEls.length-rotateElsCountLeft]
		# 	$el = $ $leftEls.eq i
		# 	@controller.addTween start-(i*(@frameDurationTime/$leftEls.length)), TweenMax.to($el, .75, { css:{ rotation: rotateDegree, transformOrigin: 'left top' } }), @frameDurationTime

		# for el, i in $rightEls
		# 	$el = $ el
		# 	@controller.addTween start-(($rightEls.length-i)*(@frameDurationTime/$rightEls.length)), TweenMax.to($el, .75, { css:{ rotation: -rotateDegree, transformOrigin: 'right top' } }), @frameDurationTime
		
		start = 2.5*@frameDurationTime
		@curtain2LeftTween = TweenMax.to(@$left, .75, { css:{ left: -@$window.outerWidth()/2 }, onUpdate: StatSocial.helpers.bind(@onCurtain2Update,@)  })
		@controller.addTween start, @curtain2LeftTween, @frameDurationTime
		@controller.addTween start, TweenMax.to(@$right, .75, { css:{ left: (@$window.outerWidth()/2) + $rightEls.first().outerWidth() } }), @frameDurationTime

		@scriptTween2  = TweenMax.to @$script2, .75, { css:{ x: 0 } }
		@controller.addTween start, @scriptTween2, @frameDurationTime

		# THE THIRD CURTAIN
		@groundTween  = TweenMax.to @$('#js-ground'), .75, { css:{ y: 0 } }
		@controller.addTween start, @groundTween, @frameDurationTime

		@bgTween  = TweenMax.to @$('#js-bg'), .75, { css:{ opacity: 1 } }
		@controller.addTween start, @bgTween, @frameDurationTime

		start = 3*@frameDurationTime
		$clouds = @$('.cloud-b')
		@cloudTween = TweenMax.to $clouds, .75, { onComplete: (=> $clouds.addClass('is-anima')), onReverseComplete:(=> $clouds.removeClass('is-anima')) }
		@controller.addTween start, @cloudTween, 1


		# -> PLANE
		start = 4*@frameDurationTime
		@$plane = @$('#js-plane')
		@$planeInner = @$plane.find('#js-plane-inner')
		@planeTween  = TweenMax.to @$plane, .75, { css:{ left: '-100%' }, onUpdate: StatSocial.helpers.bind(@onPlaneUpdate,@) }
		@controller.addTween start, @planeTween, @frameDurationTime*3

		@scriptTween21  = TweenMax.to @$script2, .75, { css:{ opacity: 0 } }
		@controller.addTween start, @scriptTween21, @frameDurationTime

		# -> BUILDINGS
		start = 6*@frameDurationTime
		$buildings  = @$('.building-b')
		for i in [0..$buildings.length]
			$el = $ $buildings.eq i
			@controller.addTween start-(($buildings.length-i)*(@frameDurationTime/$buildings.length)), 
														TweenMax.to($el, .1, { 
															css:{ y: 0, bottom: 145 },
															# ease: Bounce.easeOut,
															onComplete:(-> 
																	@target.addClass('is-show-label is-tip bounce-eff').removeClass('is-hide-label');
																	setTimeout((=>
																		@target.addClass('is-hide-label')
																	), 3990)
															),
															onReverseComplete:(-> @target.removeClass('is-show-label is-tip bounce-eff'))
														}), @frameDurationTime

		@scriptTween3  = TweenMax.to @$script2, .75, { css:{ top: '-25%' }, onUpdate: StatSocial.helpers.bind(@onCurtain2UpdateEnd,@) }
		@controller.addTween start-(@frameDurationTime/10), @scriptTween3, @frameDurationTime


		# -> BUSHES
		start = 8*@frameDurationTime
		@bushTween = TweenMax.to $clouds, .75, { onComplete: (=> @$scence3.addClass('is-show-bushes')), onReverseComplete:(=> @$scence3.removeClass('is-show-bushes')) }
		@controller.addTween start, @bushTween, 1

		# -> ROLLER-COASTER
		@$yAxes = @$('#js-roller-y')
		@$xAxes = @$('#js-roller-x')
		
		@$rollerLine1 = @$('#js-roller-line1')
		@$rollerLine2 = @$('#js-roller-line2')
		@rollerLine1  = @$rollerLine1[0]
		@rollerLine2  = @$rollerLine2[0]
		@$rollerLineBg2 = @$('#js-roller-line-bg2')
		@$rollerLineBg1 = @$('#js-roller-line-bg1')
		@$rollerLineBg4 = @$('#js-roller-line-bg4')
		@$rollerLineBg3 = @$('#js-roller-line-bg3')

		@$horizontalPattern = @$('#js-check-horizontal-pattern')
		
		@$rollerCabin1 	= @$('#js-roller-cabin1') 
		@$rollerCabinParent1 = @$rollerCabin1.parent()
		@$rollerCabin2 	= @$('#js-roller-cabin2') 
		@$rollerCabinParent2 = @$rollerCabin2.parent()
		@$rollerCabin3 	= @$('#js-roller-cabin3') 
		@$rollerCabinParent3 = @$rollerCabin3.parent()


		@$rollerCabin4 	= @$('#js-roller-cabin4') 
		@$rollerCabinParent4 = @$rollerCabin4.parent()
		@$rollerCabin5 	= @$('#js-roller-cabin5') 
		@$rollerCabinParent5 = @$rollerCabin5.parent()
		@$rollerCabin6 	= @$('#js-roller-cabin6') 
		@$rollerCabinParent6 = @$rollerCabin6.parent()
		@$rollerCabin7 	= @$('#js-roller-cabin7') 
		@$rollerCabinParent7 = @$rollerCabin7.parent()


		@$rollerText 		= @$('#js-roller-text')
		@rollerLine2Length = @rollerLine2.getTotalLength()
		@rollerText 		= @$rollerText[0]
		@rollerTextOffset = parseInt @rollerText.getAttribute('startOffset'), 10
		
		@rollerAxesTween = TweenMax.to {}, .75, { onUpdate: StatSocial.helpers.bind(@onRollerAxesUpdate,@) }
		@controller.addTween start, @rollerAxesTween, @frameDurationTime

		# --> ROLLER-COASTER BUILD
		@prepareBuildingLine 1
		@prepareBuildingLine 2

		start= 9*@frameDurationTime
		@rollerRailsTween1 = TweenMax.to { y: 500 }, .75, { y: 0, onUpdate: StatSocial.helpers.bind(@onRollerRails1Update,@) }
		@controller.addTween start, @rollerRailsTween1, 3*@frameDurationTime

		@rollerRailsTween2 = TweenMax.to { y: 500 }, 1, { y: 0, onUpdate: StatSocial.helpers.bind(@onRollerRails2Update,@) }
		@controller.addTween start, @rollerRailsTween2, 3*@frameDurationTime

		start = 12*@frameDurationTime
		@gridSimplifyTween = TweenMax.to { x: 0 }, 1, { x: 1300, onUpdate: StatSocial.helpers.bind(@onGridSimplifyUpdate,@) }
		@controller.addTween start, @gridSimplifyTween, @frameDurationTime

		start = 12*@frameDurationTime
		@lineSimplifyTween = TweenMax.to { curve: 0 }, 1, { curve: 20, onUpdate: StatSocial.helpers.bind(@onLineSimplifyUpdate,@) }
		@controller.addTween start, @lineSimplifyTween, @frameDurationTime

		start = 13*@frameDurationTime
		@rollerTextTween = TweenMax.to { offset: @rollerLine2.getTotalLength() }, 1, { offset: @rollerTextOffset, onUpdate: StatSocial.helpers.bind(@onRollerTextUpdate,@) }
		@controller.addTween start, @rollerTextTween, 2*@frameDurationTime
		
		start = 14*@frameDurationTime
		@rollerCabinsTriggerTween = TweenMax.to {}, 1, { onComplete: (=> @initRollerCabins();@showSecondTrain() ), onReverseComplete:(=> @rollerCabinsTween?.pause();@rollerCabinsTween2?.pause();@hideSecondTrain() ) }
		@controller.addTween start, @rollerCabinsTriggerTween, 1

	onLineSimplifyUpdate:-> @setLiveLinesCurve @lineSimplifyTween.target.curve

	onGridSimplifyUpdate:->
		@$horizontalPattern.attr 'transform', "translate(-#{@gridSimplifyTween.target.x},0)"

	onRollerRails1Update:()-> 
		@$rollerLine1.attr( 	'transform', "translate(0,#{@rollerRailsTween1.target.y})")
		@setLiveLinesProgress @rollerRailsTween1.totalProgress()
		@$rollerLineBg1.attr( 'transform', "translate(0,#{@rollerRailsTween1.target.y})")
		@$rollerLineBg3.attr( 'transform', "translate(0,#{@rollerRailsTween1.target.y})")

	onRollerRails2Update:()-> 
		@$rollerLine2.attr('transform', "translate(0,#{@rollerRailsTween2.target.y})")
		@$rollerLineBg2.attr('transform', "translate(0,#{@rollerRailsTween2.target.y})")
		@$rollerLineBg4.attr('transform', "translate(0,#{@rollerRailsTween2.target.y})")

	setLiveLinesProgress:(progress)->
		for point in @livePoints1
			point.setProgress progress
		for point in @livePoints2
			point.setProgress progress
		@updateLine()

	setLiveLinesCurve:(curve)->
		for point in @livePoints1
			point.curve = curve
		for point in @livePoints2
			point.curve = curve
		@updateLine()

	prepareBuildingLine:(num)->
		start = 9*@frameDurationTime
		d = @["$rollerLine#{num}"].attr('d')
		d = d.replace(/m/gi, '')
		d = d.replace(/(\d)()(\-)/gi, '$1,$3')
		a = d.split(/l|\,/gi)
		points = []
		for point, i in a by 2
			points.push 
					x: parseInt(a[i], 10)
					y: parseInt(a[i+1], 10)
					i: i
					isFixed: i is 0 or i is a.length-2

		@["livePoints#{num}"] = []
		for point in points 
			@["livePoints#{num}"].push new window.StatSocial.RollerPoint point

	updateLine:->
		@serializeLine(1)
		@serializeLine(2)

	serializeLine:(num)->
		str = 'M'
		lastPoint = {}
		for point, i in @["livePoints#{num}"]
			char = if i isnt 0 then 'S' else ''
			str += "#{char}#{point.x-point.curve},#{point.y} #{point.x+point.curve},#{point.y}"
			lastPoint = point

		@["$rollerLine#{num}"].attr('d', str)
		str += "L#{lastPoint.x},1300 L0,1300 z"
		@["$rollerLineBg#{num}"].attr('d', str)
		@["$rollerLineBg#{num+2}"].attr('d', str)

	initRollerCabins:->
		if !@rollerCabinsTween
			@rollerCabinsTween = TweenMax.to { p: @rollerLine2Length }, 6, { p: -110, delay: 2,repeatDelay: 3, repeat: -1, onUpdate: StatSocial.helpers.bind(@onRollerCabinsUpdate,@) }
		else @rollerCabinsTween.resume()

		if !@rollerCabinsTween2
			@rollerCabinsTween2 = TweenMax.to { p: @rollerLine2Length }, 6, { p: -110, repeatDelay: 3, repeat: -1, onUpdate: StatSocial.helpers.bind(@onRollerCabinsUpdate2,@) }
		else @rollerCabinsTween2.resume()

	onRollerCabinsUpdate2:->
		pathProgress = @rollerCabinsTween2.target.p
		info1 = @getRollerPathInfo pathProgress + 10, true
		info2 = @getRollerPathInfo pathProgress + 50, true
		info3 = @getRollerPathInfo pathProgress + 90, true
		info4 = @getRollerPathInfo pathProgress + 130, true
		@$rollerCabinParent4
			.attr('transform', "translate(#{info1.point.x-22}, #{info1.point.y-25}) rotate(#{info1.degree or 0}, 22, 21)")
		@$rollerCabinParent5
			.attr('transform', "translate(#{info2.point.x-22}, #{info2.point.y-25}) rotate(#{info2.degree or 0}, 22, 21)")
		@$rollerCabinParent6
			.attr('transform', "translate(#{info3.point.x-22}, #{info3.point.y-25}) rotate(#{info3.degree or 0}, 22, 21)")
		@$rollerCabinParent7
			.attr('transform', "translate(#{info4.point.x-22}, #{info4.point.y-25}) rotate(#{info4.degree or 0}, 22, 21)")

	onRollerCabinsUpdate:->
		pathProgress = @rollerCabinsTween.target.p
		info1 = @getRollerPathInfo pathProgress + 10
		info2 = @getRollerPathInfo pathProgress + 50
		info3 = @getRollerPathInfo pathProgress + 90
		@$rollerCabinParent1
			.attr('transform', "translate(#{info1.point.x-22}, #{info1.point.y-25}) rotate(#{info1.degree or 0}, 22, 21)")
		@$rollerCabinParent2
			.attr('transform', "translate(#{info2.point.x-22}, #{info2.point.y-25}) rotate(#{info2.degree or 0}, 22, 21)")
		@$rollerCabinParent3
			.attr('transform', "translate(#{info3.point.x-22}, #{info3.point.y-25}) rotate(#{info3.degree or 0}, 22, 21)")

	hideSecondTrain:->
		if !@isSecondTrainHide
			@$rollerCabinParent4.fadeOut()
			@$rollerCabinParent5.fadeOut()
			@$rollerCabinParent6.fadeOut()
			@$rollerCabinParent7.fadeOut()
			@isSecondTrainHide = true

	showSecondTrain:->
		if @isSecondTrainHide
			@$rollerCabinParent4.fadeIn()
			@$rollerCabinParent5.fadeIn()
			@$rollerCabinParent6.fadeIn()
			@$rollerCabinParent7.fadeIn()
			@isSecondTrainHide = false

	onRollerTextUpdate:()->

		pathProgress = @rollerTextTween.target.offset

		if pathProgress > 100
			info1 = @getRollerPathInfo pathProgress - 20
			info2 = @getRollerPathInfo pathProgress - 60
			info3 = @getRollerPathInfo pathProgress - 100
			@$rollerCabinParent1
				.attr('transform', "translate(#{info1.point.x-22}, #{info1.point.y-25}) rotate(#{info1.degree or 0}, 22, 21)")
			@$rollerCabinParent2
				.attr('transform', "translate(#{info2.point.x-22}, #{info2.point.y-25}) rotate(#{info2.degree or 0}, 22, 21)")
			@$rollerCabinParent3
				.attr('transform', "translate(#{info3.point.x-22}, #{info3.point.y-25}) rotate(#{info3.degree or 0}, 22, 21)")

		@rollerText.setAttribute('startOffset', "#{@rollerTextTween.target.offset}")
		
	getRollerPathInfo:(progress, isSecondLine)->
		# isDebug and debugger
		line = if !isSecondLine then @rollerLine2 else @rollerLine1
		point  		= line.getPointAtLength progress
		prevPoint = line.getPointAtLength progress - 2

		cathetus   = point.x-prevPoint.x
		hypotenuse = Math.sqrt Math.pow(point.x-prevPoint.x,2)+Math.pow(point.y-prevPoint.y,2)
		degree = Math.acos(cathetus/hypotenuse)*(180/Math.PI)
		if (point.y-prevPoint.y) < 0 then degree = -degree

		returnObj = 
			degree: degree
			point: point


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














