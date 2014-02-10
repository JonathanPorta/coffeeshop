angular.module('coffeeshop').filter "dontParentSelf", ($filter)->
	filter = (parents, cat_id)->
		newParents = []
		for parent in parents
			if parent.category_id != cat_id
				newParents.push parent
		newParents
