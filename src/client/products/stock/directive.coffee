angular.module('coffeeshop').directive "productStock", ()->
	restrict: "A"
	scope: {
		product: "="
		params: "@"
	}
	templateUrl: "products/stock/widget"
	replace: true
	transclude: false
	link: (scope, element, attrs, controller)->
		console.log "productStock Directive Link Function!"
		console.log scope, element, attrs, controller
	controller: ($scope)->
		console.log "productStock Directive ctrl"
		#Default config options
		defaults = {}

		#Setup for the override
		params = {}
		if $scope.params
			params = JSON.parse($scope.params)

		#Override defaults
		for opt, val of params
			defaults[opt] = val
		$scope.config = defaults
