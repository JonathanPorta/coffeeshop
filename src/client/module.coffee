coffeeshop = angular.module "coffeeshop", ["ngRoute"]

coffeeshop.config ($routeProvider)->
		$routeProvider.when('/products', {templateUrl:'products/list', controller:"productList"})
		$routeProvider.when('/product/edit', {templateUrl:'products/edit'})
		$routeProvider.when('/product/:productId', {templateUrl:'products/detail', controller:"productDetail"})
		$routeProvider.when('/attachment/edit', {templateUrl:'attachments/edit', controller:"attachmentEditor"})
		.otherwise({redirectTo: '/products'})

module.exports = coffeeshop

require "./storage/service.coffee"

require "./products/list/controller.coffee"
require "./products/list/directive.coffee"

require "./products/detail/controller.coffee"

require "./products/edit/directive.coffee"

require "./attachments/edit/controller.coffee"
require "./attachments/edit/directive.coffee"
