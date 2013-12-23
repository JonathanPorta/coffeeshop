angular.module('coffeeshop').directive "productEdit", ()->
	{
		restrict: "A"
		scope: {
			product: "="
			save: "&"
			params: "@"
		}
		templateUrl: "products/edit/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
			console.log "productEdit Directive - Link Function!"
			console.log scope, element, attrs, controller
		controller: ($scope)->
			console.log "productEdit Directive - Controller Function!"

			#Default config options
			defaults = {
				"title": false
			}

			#Setup for the override
			params = {}
			if $scope.params
				params = JSON.parse($scope.params)

			#Override defaults
			for opt, val of params
				defaults[opt] = val
			$scope.config = defaults
	}



##storage.ready.then (products)->
##	console.log "Storage rdy"
##	if !$scope.product
##		console.log "prod was null"
##		$scope.product = storage.build "Product", {}
##		console.log $scope.product
##console.log "end of product edit directive ctrl."
