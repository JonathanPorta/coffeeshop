angular.module('coffeeshop').directive "productDetail", ()->
	{
		restrict: "A"
		scope: {
			product: "="
		}
		templateUrl: "products/detail/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
			console.log "productDetail Directive Link Function!"
			console.log scope, element, attrs, controller
		controller: ($scope, storage)->
			console.log "productDetail Directive ctrl"
	}
