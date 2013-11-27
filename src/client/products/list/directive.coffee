angular.module('coffeeshop').directive "productList", ()->
	{
		restrict: "A"
		scope: {
			products: "="
		}
		templateUrl: "products/list/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
#			scope.$watch "products", (update, old)->
#				console.log "Products updated!", old, update

			console.log "productList Directive Link Function!"
			console.log( scope, element, attrs, controller )
	}
