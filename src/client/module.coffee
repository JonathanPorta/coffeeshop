coffeeshop = angular.module "coffeeshop", ["ngRoute"]

coffeeshop.config ($routeProvider)->
		$routeProvider.when('/products', {template:"<div>Hi</div>", controller:"productList"})
		$routeProvider.when('/product/:productId', {template:"<div>Hi</div>", controller:"productDetail"})
		.otherwise({redirectTo: '/products'})

module.exports = coffeeshop

require "./storage/service.coffee"
require "./products/list/controller.coffee"
require "./products/detail/controller.coffee"
