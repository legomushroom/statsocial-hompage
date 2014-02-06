class Point
	constructor:(@o={})->
		@vars()
		@animate()

	vars:->
		@isAnimate = true
		@x = @o.x or 0; @y = @o.y or 0
		@startY = @y
		@startX = @x
		@y = 100


	animate:->
		if !@isAnimate then return
		randomNumber = StatSocial.helpers.getRand(0,100)
		newY = StatSocial.helpers.getRand(-(@startY/2), (@startY/2))
		newX = @startX + StatSocial.helpers.getRand(-10, 10)
		@tween = TweenMax.to { y: @y, x: @x }, .5, { y: newY, x: newX, onUpdate: StatSocial.helpers.bind(@onUpdate,@), onComplete: StatSocial.helpers.bind(@animate,@) }

	onUpdate:-> 	@y = @tween.target.y; @x = @tween.target.x
	pause:-> 			@isAnimate = false; @tween.pause()
	resume:-> 		@isAnimate = true;  @tween.resume()

window.StatSocial.RollerPoint = Point
































