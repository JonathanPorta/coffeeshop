angular.module('coffeeshop').directive "productList", ()->
	{
		restrict: "A"
		scope: {
			products: "="
			type: "@"
			onSelect: "&"
		}
		templateUrl: "products/list/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
#			scope.$watch "products", (update, old)->
#				console.log "Products updated!", old, update

			console.log "productList Directive Link Function!"
			console.log( scope, element, attrs, controller )
		controller: ($scope, storage)->
			console.log "productList Directive ctrl"
			$scope.makeSelection = (entity)->
				console.log "makeSelection() Called!"
				console.log entity
				if typeof $scope.onSelect is "function"
					console.log "Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSelect entity
	}
