angular.module('coffeeshop').filter "productPrice", ($filter)->
	filter = (cents)->
		#We should be receiving a number, or a string, that represents the amount in cents.
		dollars = $filter('dollarize') cents
		$filter('currency') dollars

angular.module('coffeeshop').filter "dollarize", ($filter)->
	filter = (cents)->
		#We should be receiving a number, or a string, that represents the amount in cents.
		cents/100
