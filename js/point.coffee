class Point
	constructor:(@o={})->
		@vars()
		!@o.isFixed and @animate()

	vars:->
		@x = @o.x or 0; @y = @o.y or 0
		@startY = @y
		@startX = @x
		@stepsCnt = 5
		@curve = 0
		@animationCnt = 0
		@tweens = []

	setProgress:(progress)->
		if @o.isFixed then return
		@currentTween = @tl.getChildren()[Math.floor progress*(@stepsCnt)]
		@tl.seek progress*@stepsCnt, false

	animate:->
		@tl = new TimelineMax
		for i in [0..@stepsCnt]
			randomNumber = StatSocial.helpers.getRand(0,200)
			newY = 250+StatSocial.helpers.getRand(-randomNumber, randomNumber)
			newX = @startX + StatSocial.helpers.getRand(-10, 10)
			@prevToX = @toX or @x
			@prevToY = @toY or @y
			@toX = if i <= @stepsCnt-2 then newX else @startX
			@toY = if i <= @stepsCnt-2 then newY else @startY
			@tl.add TweenMax.to { y: @prevToY, x: @prevToX }, 1, { y: @toY, x: @toX, onUpdate: StatSocial.helpers.bind(@onUpdate,@) }
			@tl.pause()

	onUpdate:-> @y = @currentTween.target.y; @x = @currentTween.target.x

window.StatSocial.RollerPoint = Point
































