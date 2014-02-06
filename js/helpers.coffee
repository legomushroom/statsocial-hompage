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



window.StatSocial ?= {}
window.StatSocial.helpers = new Helpers