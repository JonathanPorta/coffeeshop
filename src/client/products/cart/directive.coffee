angular.module('coffeeshop').directive "productCart", ()->
	restrict: "A"
	scope: {
		product: "="
	}
	templateUrl: "products/cart/widget"
	replace: true
	transclude: false
	link: (scope, element, attrs, controller)->
		console.log "productCart Directive Link Function!"
		console.log scope, element, attrs, controller
	controller: ($scope)->
		console.log "productCart Directive ctrl"
