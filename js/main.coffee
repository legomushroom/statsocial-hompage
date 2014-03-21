class App 
	constructor:->
		@vars()
		@initScroll()
		@initController()
		@buildAnimations()
		@listenKeys()
		@initMap()
		@playSuggest()
		@addCssClasses()
		@loopSequence = StatSocial.helpers.bind @loopSequence, @
		# @initParallax()
		# $('#js-toggle-btn').on 'click', => $('#js-curtain3').toggleClass('is-night')
	
	vars:->
		@$main =  $('#js-main')
		@$body = 	$(document.body)
		@scrollPos = 0
		@$window = $(window)
		@$window.height()
		# @$mainLogo 	= @$('#js-main-logo')
		@$script1 	= @$('#js-script1')
		@$script2 	= @$('#js-script2')
		@$scence  	= @$('#js-curtain1')
		@$scence2 	= @$('#js-curtain2')
		@$scence3 	= @$('#js-curtain3')
		@$carousel 	= @$('#js-carousel')
		@$plane1 		= @$('#js-plane1')
		@$plane2 		= @$('#js-plane2')
		@$plane3 		= @$('#js-plane3')
		@$plane4 		= @$('#js-plane4')
		@$ground 		= @$('#js-ground')
		@$scrollSuggest = $('#js-scroll-suggest')
		@$mouseSuggest 	= $('#js-scroll-suggest-mouse')
		@$keysSuggest 	= $('#js-scroll-suggest-keys')
		@$touchSuggest 	= $('#js-scroll-suggest-touch')
		@$pagesBtns 		= $('#js-pages-btns')
		@$playBtn 			= $('#js-pages-btns-play')
		@$mainMenu 			= $('#js-main-menu')
		@$menuSuggest 	= $('#js-menu-suggest')
		@prevPlaneProgress = -1
		@maxScroll = -19000
		@readDelay = 3000
		@startPoints = []
		@readDelayItems = [3,4,5,6,8,10]


	hideMenu:-> 
		@$mainMenu.addClass 'is-hidden'
		@$menuSuggest.removeClass 'h-g-i'
		@isMenuShow = false

	showMenu:-> 
		@$mainMenu.removeClass 'is-hidden'
		@$menuSuggest.addClass 'h-g-i'
		@isMenuShow = true

	initController:->
		@controller = $.superscrollorama
											triggerAtCenter: false
											playoutAnimations: true


	loopSequence:->
		num = @setCurrentScenseNum @currSequenceTweenNum+1

		@currSequenceTween = TweenMax.to @scroller, @startPoints[@currSequenceTweenNum].dur, 	{ 
			y: -@startPoints[@currSequenceTweenNum].start
			onUpdate:   (=> @controller.setScrollContainerOffset(0, -(@scroller.y)).triggerCheckAnim(true))
			onComplete:=>
				if @currSequenceTweenNum < @startPoints.length
					@sequenceLoopTimer = setTimeout @loopSequence, @startPoints[@currSequenceTweenNum].delay or 0
					if @currSequenceTweenNum is @startPoints.length-1
						@stopLoopSequence()
		}

		@$playBtn.addClass 'is-playing'

	addCssClasses:->
		@$mainMenu.addClass 'is-allow-transition'
		if StatSocial.helpers.isMobile()
			$(document.body).addClass 'at-mobiles'

	stopLoopSequence:->
		clearTimeout @sequenceLoopTimer
		@currSequenceTween?.kill()
		@play = false
		@$playBtn.removeClass 'is-playing'

	setCurrentScenseNum:(num)->
		if (@currSequenceTweenNum is num) or (num >= @startPoints.length) then return num
		@currSequenceTweenNum = num
		@$pagesBtnsChildren.filter('.is-check').removeClass 'is-check'
		@$pagesBtnsChildren.eq(num+1).addClass 'is-check'
		num

	initMap:->
		for point, i in @startPoints
			@$pagesBtns.append $ "<div class='pages-btns__btn #{if i is 0 then 'is-check' else null }' />"
		@$pagesBtnsChildren =  @$pagesBtns.children()
		
		@$pagesBtns.on 'click', '.pages-btns__btn', (e)=>
			@stopLoopSequence()
			num = $(e.target).index()-1
			@currSequenceTween = TweenMax.to @scroller, @startPoints[num].dur, 	{ 
				y: -@startPoints[num].start
				onUpdate:(=> @controller.setScrollContainerOffset(0, -(@scroller.y)).triggerCheckAnim(true) ) 
			}
			@setCurrentScenseNum num

		it = @
		@$pagesBtns.on 'click', '#js-pages-btns-play', (e)->
			$it = $(this)
			it.play = !@play
			$it.toggleClass 'is-playing', it.play
			if it.play and (it.currSequenceTweenNum < it.startPoints.length-1)
				it.loopSequence()
			else it.stopLoopSequence()

	playSuggest:->
		@$scrollSuggest.show()

		if !StatSocial.helpers.isMobile()
			@$keysSuggest.hide()
			@$mouseSuggest.show()
			currBlock = @$mouseSuggest
			@suggestInterval = setInterval =>
				if currBlock is @$mouseSuggest
					@$mouseSuggest.hide()
					@$keysSuggest.fadeIn()
					currBlock = @$keysSuggest
				else
					@$keysSuggest.hide()
					@$mouseSuggest.fadeIn()
					currBlock = @$mouseSuggest
			, 5000
		else 
			@$touchSuggest.show()
			@$mouseSuggest.hide()
			@$keysSuggest.hide()

	stopSuggest:->
		clearInterval @suggestInterval
		@$keysSuggest.hide()
		@$mouseSuggest.hide()
		@$touchSuggest.hide()
		@$scrollSuggest.hide()

	listenKeys:->
		scrollStep = @frameDurationTime/4
		@play = false
		@currSequenceTweenNum = 0
		$document = $(document)
		$document.on 'keyup', (e)=>
			switch e.keyCode
				when 32
					@play = !@play
					if @play and (@currSequenceTweenNum < @startPoints.length-1)
						@loopSequence()
					else @stopLoopSequence()

		currTweenKeydown = null
		stepSize = @frameDurationTime
		$document.on 'keydown', (e)=>
			switch e.keyCode
				when 39, 40
					@setCurrentScenseNum if @currSequenceTweenNum < @startPoints.length-1 then @currSequenceTweenNum+1 else @currSequenceTweenNum
					@stopLoopSequence()
					@currSequenceTween = TweenMax.to @scroller, @startPoints[@currSequenceTweenNum].dur, 	{ 
						y: -@startPoints[@currSequenceTweenNum].start
						onUpdate:(=> @controller.setScrollContainerOffset(0, -(@scroller.y)).triggerCheckAnim(true) ) 
					}
				when 37, 38
					@setCurrentScenseNum if @currSequenceTweenNum > 0 then @currSequenceTweenNum-1 else @currSequenceTweenNum
					@stopLoopSequence()
					@currSequenceTween = TweenMax.to @scroller, @startPoints[@currSequenceTweenNum+1].dur, 	{ 
						y: -@startPoints[@currSequenceTweenNum].start
						onUpdate:(=> @controller.setScrollContainerOffset(0, -(@scroller.y)).triggerCheckAnim(true) ) 
					}

		$('#js-menu-btn').on 'click', (e)=> 
			if (@isMenuShow = !@isMenuShow) then @showMenu()
			else @hideMenu()
			e.stopPropagation()

		$(document.body).on 'click', (e)=>
			@hideMenu()
			e.stopPropagation()


	initScroll:->
		@scroller = new IScroll '#js-main', { probeType: 3, mouseWheel: true, deceleration: 0.001 }
		document.addEventListener 'touchmove', ((e)-> e.preventDefault()), false
		it = @
		@scroller.on 'scroll',  	-> it.updateScrollPos this, it
		@scroller.on 'scrollEnd', -> it.updateScrollPos this, it

	# initParallax:->
	# 	@$scence.parallax()
	# 	@$scence2.parallax()

	updateScrollPos:(that, it)->
		@stopLoopSequence()
		(that.y < it.maxScroll) and (that.y = it.maxScroll)
		it.controller.setScrollContainerOffset(0, -(that.y>>0)).triggerCheckAnim(true)
		it.calcCurrentScenseNum(that)
		it.isMenuShow and it.hideMenu()

	calcCurrentScenseNum:(that)->
		num = 0
		for point, i in @startPoints
			if -that.y > point.start
				num = i
		@setCurrentScenseNum num

	onBuildingsUpdate:->
		method = if @curtainTextTween2.totalProgress() >= 1 then 'hide' else 'show'
		@$scence[method]()

	scrollStart:->
		@stopSuggest()
		@$menuSuggest.addClass('is-transparent').hide()

	scrollReverseStart:->
		@playSuggest()
		@$menuSuggest.removeClass('is-transparent').show()

	scrollEnd:-> @$menuSuggest.show()
	scrollReverseEnd:-> @$menuSuggest.hide()

	buildAnimations:->
		$quoCurtain = @$('#js-quo-curtain')
		$tickets = @$('#js-tickets')
		$ticket1 = @$('#js-ticket1')
		$ticket2 = @$('#js-ticket2')
		$clip 	 = @$('#js-clip')

		@frameDurationTime = 1000

		# THE FIRST CURTAIN
		@curtainTween1 	= TweenMax.to @$('#js-left-curtain'), 	1,  { left: '-50%'}
		# @curtainTween1 	= TweenMax.to @$('#js-left-curtain'), 	1,  { rotation: 90, transformOrigin: 'center top' }
		# @curtainTween1 	= TweenMax.to @$('#js-left-curtain'), 	1,  { rotation: 90, transformOrigin: 'center top', top: '100%' }
		@curtainTween2 	= TweenMax.to @$('#js-right-curtain'), 	1, 	{	left: '100%', onStart: StatSocial.helpers.bind(@scrollStart,@), onReverseComplete: StatSocial.helpers.bind(@scrollReverseStart,@)}
		
		start = 1
		dur = @frameDurationTime
		@startPoints.push 
			start: start
			delay: 0
			dur: 1

		@controller.addTween start, @curtainTween2, dur

		@rightPeelTween 	= TweenMax.to @$('#js-right-peel, #js-right-peel-gradient'), 	1, 	{ css:{ width: '100%' }}
		@controller.addTween start, @rightPeelTween, dur
		@curtainTextTween2	= TweenMax.to @$('#js-quo-curtain'), 1, { css:{ left: '-100%' } }
		@controller.addTween start, @curtainTextTween2, dur

		start = start + dur
		dur = @frameDurationTime
		

		@controller.addTween start, @curtainTween1, dur
		@leftPeelTween 	= TweenMax.to @$('#js-left-peel, #js-left-peel-gradient'), 	1, 	{ css:{ width: '100%' }}
		@controller.addTween start, @leftPeelTween, @frameDurationTime

		start = start + dur - @frameDurationTime
		dur = @frameDurationTime

		@groundTween  = TweenMax.to @$ground, 1, { css:{ y: 0 } }
		@controller.addTween start, @groundTween, dur

		@bgTween  = TweenMax.to @$('#js-bg'), 1, { css:{ opacity: 1 } }
		@controller.addTween start, @bgTween, dur

		start = start + dur
		dur = 1
		$clouds = @$('.cloud-b')
		@cloudTween = TweenMax.to $clouds, 1, { onComplete: (=> $clouds.addClass('is-anima')), onReverseComplete:(=> $clouds.removeClass('is-anima')) }
		@controller.addTween start, @cloudTween, dur
		
		# -> BUILDINGS
		start = start + dur + (@frameDurationTime/2)
		dur = @frameDurationTime

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
														}), dur

		@curtainTextTween2  = TweenMax.to @$('.underline-text'), 1, { css:{ top: '-25%' }, onReverseComplete:(=> @$('.underline-text').css 'top': '50%'), onUpdate: StatSocial.helpers.bind(@onBuildingsUpdate,@) }
		@controller.addTween start-(@frameDurationTime/10), @curtainTextTween2, dur
		
		# -> PLANE
		start = start + dur - (@frameDurationTime/1.5)
		dur = 3*@frameDurationTime
		@startPoints.push 
			start: start + (@frameDurationTime)
			delay: 3000
			dur: 3

		@$moon = @$('#js-moon')

		it = @
		@$plane1Inner = @$plane1.find('#js-plane-inner')
		planeTween1  = TweenMax.to @$plane1, 1, { 
				left: '-100%',
				onUpdate:-> 
					@oldP ?= -999; p = planeTween1.progress()
					method = if @oldP > p then 'addClass' else 'removeClass'
					it.$plane1Inner[method]('is-flip')
					@oldP = p
			}
		@controller.addTween start, planeTween1, dur

		# -> BUSHES
		start = start + dur - 2*@frameDurationTime
		dur = @frameDurationTime

		$bushes = $('.curtain3--bush-lh')
		for bush, i in $bushes
			$bush = $ bush
			@controller.addTween start, TweenMax.to($bush, .75, { scale: 1 }), dur
		# -> ROLLER-COASTER
		@$yAxes = @$('#js-roller-y')
		@$yAxesArrow = @$('#js-axes-arrow-y')
		@$xAxes = @$('#js-roller-x')
		@$xAxesArrow = @$('#js-axes-arrow-x')

		@$rollerLine1 = @$('#js-roller-line1')
		@$rollerLine2 = @$('#js-roller-line2')
		@rollerLine1  = @$rollerLine1[0]
		@rollerLine2  = @$rollerLine2[0]

		if StatSocial.helpers.isIE()
			@rollerLine1.setAttribute 'marker-mid', 'none'

		@$rollerLineBg2 = @$('#js-roller-line-bg2')
		@$rollerLineBg1 = @$('#js-roller-line-bg1')
		@$rollerLineBg4 = @$('#js-roller-line-bg4')
		@$rollerLineBg3 = @$('#js-roller-line-bg3')

		@$horizontalPattern = @$('#js-check-horizontal-pattern')
		@$horizontalPatternDouble = @$('#js-check-horizontal-pattern-double')
		
		@$rollerCabin1 	= @$('#js-roller-cabin1') 
		@$rollerCabinParent1 = @$rollerCabin1.parent()
		@$rollerCabin2 	= @$('#js-roller-cabin2') 
		@$rollerCabinParent2 = @$rollerCabin2.parent()
		@$rollerCabin3 	= @$('#js-roller-cabin3') 
		@$rollerCabinParent3 = @$rollerCabin3.parent()

		@$markerCircle = @$('#js-marker-circle')

		@$rollerCabin4 	= @$('#js-roller-cabin4') 
		@$rollerCabinParent4 = @$rollerCabin4.parent()
		@$rollerCabin5 	= @$('#js-roller-cabin5') 
		@$rollerCabinParent5 = @$rollerCabin5.parent()
		@$rollerCabin6 	= @$('#js-roller-cabin6') 
		@$rollerCabinParent6 = @$rollerCabin6.parent()
		@$rollerCabin7 	= @$('#js-roller-cabin7') 
		@$rollerCabinParent7 = @$rollerCabin7.parent()
		@$ferrisWheel = @$('#js-ferris-wheel')


		@$rollerText 		= @$('#js-roller-text')
		@rollerLine2Length = @rollerLine2.getTotalLength()
		@rollerText 		= @$rollerText[0]
		@rollerTextOffset = parseInt @rollerText.getAttribute('startOffset'), 10
		
		@rollerAxesTween = TweenMax.to {}, 1, { onUpdate: StatSocial.helpers.bind(@onRollerAxesUpdate,@) }
		@controller.addTween start, @rollerAxesTween, dur

		@rollerAxesArrowTween = TweenMax.to {}, 1, { onUpdate: StatSocial.helpers.bind(@onRollerAxesArrowsUpdate,@) }
		@controller.addTween start, @rollerAxesArrowTween, dur

		# --> ROLLER-COASTER BUILD
		@prepareBuildingLine 1
		@prepareBuildingLine 2

		start = start + dur - (@frameDurationTime)
		dur = 3*@frameDurationTime

		@rollerRailsTween1 = TweenMax.to { y: 500 }, .75, { y: 0, onUpdate: StatSocial.helpers.bind(@onRollerRails1Update,@) }
		@controller.addTween start, @rollerRailsTween1, dur

		@rollerRailsTween2 = TweenMax.to { y: 500 }, 1, { y: 0, onUpdate: StatSocial.helpers.bind(@onRollerRails2Update,@) }
		@controller.addTween start, @rollerRailsTween2, dur

		start = start + dur
		dur = @frameDurationTime

		@gridSimplifyTween = TweenMax.to { x: 0 }, 1, { x: 1300, onUpdate: StatSocial.helpers.bind(@onGridSimplifyUpdate,@) }
		@controller.addTween start, @gridSimplifyTween, dur

		@lineSimplifyTween = TweenMax.to { curve: 0 }, 1, { curve: 40, onUpdate: StatSocial.helpers.bind(@onLineSimplifyUpdate,@) }
		@controller.addTween start, @lineSimplifyTween, dur

		@axesSimplifyTween = TweenMax.to @$('#js-roller-x, #js-roller-y, #js-axes-arrow-x, #js-axes-arrow-y'), 1, { opacity: 0 }
		@controller.addTween start, @axesSimplifyTween, dur

		start = start + dur 
		dur = 3*@frameDurationTime
		@startPoints.push 
			start: start+@frameDurationTime
			delay: 3000
			dur: 3

		@rollerTextTween = TweenMax.to { offset: @rollerLine2.getTotalLength() }, 1, { offset: @rollerTextOffset, onUpdate: StatSocial.helpers.bind(@onRollerTextUpdate,@), onStart:=> @showTrain1() }
		@controller.addTween start, @rollerTextTween, dur
		
		start = start + dur - (@frameDurationTime/2)
		dur = 1
		@rollerCabinsTriggerTween = TweenMax.to {}, 1, { onComplete: (=> @initRollerCabins();@showTrain2() ), onReverseComplete:(=> @rollerCabinsTween?.pause();@rollerCabinsTween2?.pause();@hideTrain2(); ) }
		@controller.addTween start, @rollerCabinsTriggerTween, dur

		start = start + dur - (@frameDurationTime)
		dur = 1
		@carouselTriggerTween = TweenMax.to {}, 1, { onComplete:(=>@$scence3.addClass('is-show-carousel'); setTimeout (=> @$carousel.addClass('is-open') ), 10), onReverseComplete:=>( @$carousel.removeClass('is-open'); setTimeout (=> @$scence3.removeClass('is-show-carousel') ), 100) }
		@controller.addTween start, @carouselTriggerTween, dur

		start = start + dur
		dur = 3*@frameDurationTime
		@startPoints.push 
			start: start+(0.75*@frameDurationTime)
			delay: 4000
			dur: 1

		it = @
		@$plane2Inner = @$plane2.find('#js-plane-inner')
		planeTween2  = TweenMax.to @$plane2, 1, { 
				left: '100%',
				onUpdate:-> 
					@oldP ?= 999; p = planeTween2.progress()
					method = if @oldP < p then 'addClass' else 'removeClass'
					it.$plane2Inner[method]('is-flip')
					@oldP = p
			}
		@controller.addTween start, planeTween2, dur

		start = start + dur - (2*@frameDurationTime)
		dur = 1
		@ferrisWheelTriggerTween = TweenMax.to {}, 1, { onComplete:(=>@$scence3.addClass('is-show-ferris-wheel'); setTimeout( (=> @$ferrisWheel.addClass('is-open') ), 10)), onReverseComplete:=>( @$ferrisWheel.removeClass('is-open'); setTimeout (=> @$scence3.removeClass('is-show-ferris-wheel') ), 100) }
		@controller.addTween start, @ferrisWheelTriggerTween, dur

		start = start + dur + @frameDurationTime
		dur = 3*@frameDurationTime
		@startPoints.push 
			start: start+(@frameDurationTime/1.5)
			delay: 3000
			dur: 1

		@ferrisText 		= @$('#js-ferris-text')[0]
		@ferrisTextPath = @$('#ferris-script')[0]

		@ferrisTextTween = TweenMax.to { offset: 2300 }, 1, { offset: 100, onUpdate: StatSocial.helpers.bind(@onFerrisTextUpdate,@) }
		@controller.addTween start, @ferrisTextTween, dur

		start = start + dur - (1.5*@frameDurationTime)
		dur = @frameDurationTime

		@moonTween  = TweenMax.to @$moon, 1, { x: 0, y: 0 }
		@controller.addTween start, @moonTween, dur

		$cloudParts = @$('.cloud-b > *')
		$iconBanner = $('.icon-banner')
		@controller.addTween start, TweenMax.to(@$('.cabin--base, .icon-banner'), 1, { backgroundColor: '#f2d577' }), dur
		@controller.addTween start, TweenMax.to(@$('#js-bg'), 1, { backgroundColor: '#095273' }), dur
		@controller.addTween start, TweenMax.to($cloudParts, 1, { backgroundColor: '#4b99bd', onStart:(=> $cloudParts.addClass('no-transition-g-i'); $iconBanner.addClass('no-transition-g-i')), onReverseComplete:(=>$cloudParts.removeClass('no-transition-g-i'); $iconBanner.removeClass('no-transition-g-i')) }), dur
		@controller.addTween start, TweenMax.to(@$('.building-b'), 1, { backgroundColor: '#13688d' }), dur
		@controller.addTween start, TweenMax.to(@$('.human'), 1, { backgroundColor: '#153750' }), dur
		@controller.addTween start, TweenMax.to(@$('.bush-b > .part-be'), 1, { backgroundColor: '#70bb69' }), dur
		@controller.addTween start, TweenMax.to(@$('.bush-b.is-light > .part-be'), 1, { backgroundColor: '#55d38c' }), dur
		@controller.addTween start, TweenMax.to(@$('.ribbon-b, .ribbon-b > .rope-be, .ribbon-b > .rope2-be'), 1, { backgroundColor: '#6ab4d7' }), dur
		@controller.addTween start, TweenMax.to(@$('.ribbon-b > .text-be'), 1, { color: '#ffffff' }), dur
		@controller.addTween start, TweenMax.to(@$('.ribbon-b > .tale-be'), 1, { borderTopColor: '#6ab4d7' }), dur
		@controller.addTween start, TweenMax.to(@$('.ribbon-b > .tale2-be'), 1, { borderBottomColor: '#6ab4d7' }), dur
		@controller.addTween start, TweenMax.to(@$('.building-b > .tip-be'), 1, { borderBottomColor: '#18688d' }), dur
		@controller.addTween start, TweenMax.to(@$('.line, .check-pattern'), 1, { stroke: '#1b7daa' }), dur
		@controller.addTween start, TweenMax.to(@$('.line1, .check-pattern1'), 1, { stroke: '#2590be' }), dur
		@controller.addTween start, TweenMax.to(@$('.marker-circle'), 1, { fill: '#2590be' }), dur
		@controller.addTween start, TweenMax.to(@$('.svg-cabin-wheel'), 1, { fill: '#13527b' }), dur
		@controller.addTween start, TweenMax.to(@$('.svg-cabin-base'), 1, { fill: '#237ca6' }), dur
		@controller.addTween start, TweenMax.to(@$('.svg-cabin-base2'), 1, { fill: '#3f98c2' }), dur
		@controller.addTween start, TweenMax.to(@$('.svg-cabin-base3'), 1, { fill: '#1c7691' }), dur
		@controller.addTween start, TweenMax.to(@$('.svg-cabin-human'), 1, { fill: '#153750' }), dur
		@controller.addTween start, TweenMax.to(@$ground, 1, { backgroundColor: '#333040' }), dur

		start = start + dur
		dur = @frameDurationTime
		@startPoints.push 
			start: start
			delay: 1000
			dur: 1

		@moonTween = TweenMax.to $('.moon-n-text--side'), 1, { y: -60, opacity: 0 }
		@moonOpacityTween = TweenMax.to $('.moon--chart'), 1, { opacity: 0 }
		@controller.addTween start, @moonTween, dur
		@controller.addTween start, @moonOpacityTween, dur

		start = start + dur - (@frameDurationTime/2)
		dur = 3*@frameDurationTime

		it = @
		@$plane3Inner = @$plane3.find('#js-plane-inner')
		planeTween3  = TweenMax.to @$plane3, 1, { 
				left: '-100%',
				onUpdate:-> 
					@oldP ?= -999; p = planeTween3.progress()
					method = if @oldP > p then 'addClass' else 'removeClass'
					it.$plane3Inner[method]('is-flip')
					@oldP = p
			}
		@controller.addTween start, planeTween3, dur
		
		start = start + dur - (2*@frameDurationTime)
		dur = @frameDurationTime
		@startPoints.push 
			start: start
			delay: 3000
			dur: 1

		@entranceTween  = TweenMax.to @$('#js-entrance'), 1, { y: 0 }
		@controller.addTween start, @entranceTween, dur

		start = start + dur - (@frameDurationTime/2)
		dur = @frameDurationTime

		@$baloonsLayer1 = @$('.js-baloon__layer1')
		@$baloonsLayer2 = @$('.js-baloon__layer2')
		@$baloonsLayer3 = @$('.js-baloon__layer3')

		@baloonsTween1  = TweenMax.to @$baloonsLayer1, 1, { marginTop: 0, onUpdate: StatSocial.helpers.bind(@onBaloonsUpdate1,@) }
		@controller.addTween start, @baloonsTween1, dur

		@baloonsTween2  = TweenMax.to @$baloonsLayer2, 1, { marginTop: 0, onUpdate: StatSocial.helpers.bind(@onBaloonsUpdate2,@) }
		@controller.addTween start + (@frameDurationTime/6), @baloonsTween2, dur

		@baloonsTween3  = TweenMax.to @$baloonsLayer3, 1, { marginTop: 0, onUpdate: StatSocial.helpers.bind(@onBaloonsUpdate3,@) }
		@controller.addTween start + (@frameDurationTime/8), @baloonsTween3, dur

		@groundKonfettiTween  = TweenMax.to @$('#js-ground-confetti'), 1, { opacity: 1 }
		@controller.addTween start, @groundKonfettiTween, dur

		start = start + dur 
		dur = 1
		$animas = @$('.anima-fork')
		@logosTriggerTween = TweenMax.to {}, 1, { 
			onComplete: (=> 
				for anima, i in $animas
					if i is 0 then $(anima).show()
					else do (anima)=>
						setTimeout =>
							$(anima).show()
						, (StatSocial.helpers.getRand(0,150))*10
			),
			onReverseComplete:(=> $animas.hide() ) 
		}
		@controller.addTween start, @logosTriggerTween, dur

		start = start - (@frameDurationTime/5)
		dur = 3*@frameDurationTime
		it = @
		@$plane4Inner = @$plane4.find('#js-plane-inner')
		planeTween4  = TweenMax.to @$plane4, 1, { 
				left: '100%',
				onUpdate:-> 
					@oldP ?= 999; p = planeTween4.progress()
					method = if @oldP < p then 'addClass' else 'removeClass'
					it.$plane4Inner[method]('is-flip')
					@oldP = p
			}
		@controller.addTween start, planeTween4, dur

		start = start + dur - (2*@frameDurationTime)
		dur = @frameDurationTime
		@startPoints.push 
			start: start
			delay: 3000
			dur: 3

		@ticketsTween  = TweenMax.to $tickets, 1, { y: 0 }
		@controller.addTween start, @ticketsTween, dur

		start = start + dur - (@frameDurationTime/2)
		dur = @frameDurationTime
		@startPoints.push 
			start: start + @frameDurationTime
			delay: 3
			dur: 1

		@ticket1  = TweenMax.to $ticket1, 1, { rotation: -20, y: -20, x: -50 }
		@controller.addTween start, @ticket1, dur

		@clip  = TweenMax.to $clip, 1, { rotation: -3, y: 56, x: -70 }
		@controller.addTween start, @clip, dur

		@ticket2  = TweenMax.to $ticket2, 1, { rotation: -10, onUpdate: StatSocial.helpers.bind(@onTicket2Update,@) }

		@controller.addTween start, @ticket2, dur

	onTicket2Update:-> 
		if (@ticket2.progress() < 1)  
			if !@isReverseEnd 
				@isReverseEnd = true
				@scrollReverseEnd()
		else 
			@scrollEnd()
			@isReverseEnd = false

	onBaloonsUpdate1:->
		if @baloonsTween1.totalProgress() >= 1
			@$baloonsLayer1.addClass('oscillate-eff')
		else
			@$baloonsLayer1.removeClass('oscillate-eff')

	onBaloonsUpdate2:->
		if @baloonsTween2.totalProgress() >= 1
			@$baloonsLayer2.addClass('oscillate2-eff')
		else
			@$baloonsLayer2.removeClass('oscillate2-eff')

	onBaloonsUpdate3:->
		if @baloonsTween3.totalProgress() >= 1
			@$baloonsLayer3.addClass('oscillate3-eff')
		else
			@$baloonsLayer3.removeClass('oscillate3-eff')

	onFerrisTextUpdate:->
		pathProgress = @ferrisTextTween.target.offset
		@ferrisText.setAttribute('startOffset', "#{@ferrisTextTween.target.offset}")

	onLineSimplifyUpdate:-> 
		if @lineSimplifyTween.totalProgress() > 0
			@$markerCircle[0].setAttribute('class','marker-circle is-no-stroke')
		else @$markerCircle[0].setAttribute('class','marker-circle')

		@setLiveLinesCurve @lineSimplifyTween.target.curve

	onGridSimplifyUpdate:->
		@$horizontalPattern.attr 'transform', 	"translate(-#{@gridSimplifyTween.target.x},0)"
		@$horizontalPatternDouble.attr 'transform', "translate(-#{@gridSimplifyTween.target.x},0)"
		
	onRollerRails1Update:()-> 
		if @rollerRailsTween1.totalProgress() < 1 then @hideTrain1()

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
		a = d.split(/l|\,|\s/gi)
		b = []
		for point, i in a
			(point isnt '') and b.push point
		points = []
		for point, i in b by 2
			points.push 
					x: parseInt(b[i], 10)
					y: parseInt(b[i+1], 10)
					i: i
					isFixed: i is 0 or i is b.length-2

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

	hideTrain1:->
		if !@isFirstTrainHide
			@$rollerCabinParent1.fadeOut()
			@$rollerCabinParent2.fadeOut()
			@$rollerCabinParent3.fadeOut()
			@isFirstTrainHide = true

	showTrain1:->
		if @isFirstTrainHide
			@$rollerCabinParent1.fadeIn()
			@$rollerCabinParent2.fadeIn()
			@$rollerCabinParent3.fadeIn()
			@isFirstTrainHide = false

	hideTrain2:->
		if !@isSecondTrainHide
			@$rollerCabinParent4.fadeOut()
			@$rollerCabinParent5.fadeOut()
			@$rollerCabinParent6.fadeOut()
			@$rollerCabinParent7.fadeOut()
			@isSecondTrainHide = true

	showTrain2:->
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
		@$yAxes.attr('transform', "translate(0,#{570-(550*progress)})")
		@$xAxes.attr('transform', "translate(#{-1240+(1240*progress)},0)")

	onRollerAxesArrowsUpdate:->
		progress = @rollerAxesTween.totalProgress()
		@$yAxesArrow.attr('transform', "translate(2.5,#{552-(550*progress)})")
		@$xAxesArrow.attr('transform', "translate(#{-32+(1240*progress)},482) rotate(90,11,21)")

	setPlaneText:(text)->
		if @currPlaneText isnt text
			@$planeText.text text
			@currPlaneText = text

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
		if @$left.offset().left isnt 0		
			@$script2.css left: Math.max @$left.offset().left+@$left.outerWidth(), @$window.outerWidth()/2 - @$script2.outerWidth()/2 - 20

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














