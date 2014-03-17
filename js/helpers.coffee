class Helpers
	bind:(func, context) ->
		wrapper = ->
			args = Array::slice.call(arguments)
			unshiftArgs = bindArgs.concat(args)
			func.apply context, unshiftArgs
		bindArgs = Array::slice.call(arguments, 2)
		wrapper

	extend:(obj, obj2)->
		for key, value of obj2
			if obj2[key]? then obj[key] = value
		obj

	getRand:(min,max)->
		Math.floor((Math.random() * ((max + 1) - min)) + min)

	isIE:->
		if @isIECache then return @isIECache
		undef = undefined # Return value assumes failure.
		rv = -1
		ua = window.navigator.userAgent
		msie = ua.indexOf("MSIE ")
		trident = ua.indexOf("Trident/")
		if msie > 0
		  
		  # IE 10 or older => return version number
		  rv = parseInt(ua.substring(msie + 5, ua.indexOf(".", msie)), 10)
		else if trident > 0
		  
		  # IE 11 (or newer) => return version number
		  rvNum = ua.indexOf("rv:")
		  rv = parseInt(ua.substring(rvNum + 3, ua.indexOf(".", rvNum)), 10)
		@isIECache = (if (rv > -1) then rv else undef)
		@isIECache



window.StatSocial ?= {}
window.StatSocial.helpers = new Helpers