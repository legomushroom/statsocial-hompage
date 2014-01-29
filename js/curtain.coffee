class Curtain
	constructor:(@o={})->
		@vars()
		@rotate()

	vars:->
		@$image1 = $('#curtain-image1')
		@$image2 = $('#curtain-image2')
		@animate 			= StatSocial.helpers.bind @animate, @

	rotate:->
		# it = @
		# img1 = it.$image1[0]
		# img2 = it.$image2[0]
		# tween1 = new TWEEN.Tween({ r: -180 })
		# 					.to({ r: 180 }, 30000)
		# 					.onUpdate(->
		# 						img1.setAttribute  'style', "-webkit-transform:rotate(#{@r}deg) translateZ(0)"
		# 					).start().repeat(99999999999)

		# tween1 = new TWEEN.Tween({ r: 180 })
		# 					.to({ r: -180 }, 30000)
		# 					.onUpdate(->
		# 						img2.setAttribute  'style', "-webkit-transform:rotate(#{@r}deg) translateZ(0)"
		# 					).start().repeat(99999999999)

		# @animate()

	animate:->
		requestAnimationFrame(@animate)
		TWEEN.update()



new Curtain