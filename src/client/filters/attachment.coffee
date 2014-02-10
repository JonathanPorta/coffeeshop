angular.module('coffeeshop').filter "attr", ($filter)->
	filter = (attrs, types)->
		console.log "Attachment Filter", attrs, types
		matches = []
		for a in attrs
			if a.type in types
				matches.push a
		matches
