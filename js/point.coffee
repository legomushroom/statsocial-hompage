class Point
	constructor:(@o={})->
		@vars()
		@animate()

	vars:->
		@isAnimate = false
		@x = @o.x or 0; @y = @o.y or 0
		@startY = @y
		@startX = @x
		@animationCnt = 0

	animate:->
		if !@isAnimate then return
		console.log 'animate'
		@animationCnt++
		randomNumber = StatSocial.helpers.getRand(0,200)
		newY = 250+StatSocial.helpers.getRand(-randomNumber, randomNumber)
		newX = @startX + StatSocial.helpers.getRand(-10, 10)
		toX = if @animationCnt <= 4 then newX else @startX
		toY = if @animationCnt <= 4 then newY else @startY
		@tween = TweenMax.to { y: @y, x: @x }, .5, { y: toY, x: toX, onUpdate: StatSocial.helpers.bind(@onUpdate,@), onComplete: StatSocial.helpers.bind(@animate,@) }

	onUpdate:-> 	@y = @tween.target.y; @x = @tween.target.x
	pause:-> 			@isAnimate = false; @tween.pause()
	resume:-> 		@isAnimate = true;  @tween.resume()

window.StatSocial.RollerPoint = Point
































