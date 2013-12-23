angular.module('coffeeshop').directive "prettyPrint", ($compile)->
	restrict: "A"
	scope: {
		"attachment": "="
		"params": "@"
	}
	templateUrl: "pretty/widget"
	replace: true
	transclude: true
	controller: ($scope, $element, $attrs, $transclude)->
		console.log "prettyPrint Directive - Controller Function"
		console.log $scope, $element, $attrs, $transclude
		#Default config options
		defaults = {
			"link": true
		}

		#Setup for the override
		params = {}
		if $scope.params
			params = JSON.parse($scope.params)

		#Override defaults
		for opt, val of params
			defaults[opt] = val
		$scope.config = defaults
