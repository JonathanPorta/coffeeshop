coffeeshop = angular.module "coffeeshop", ["ngRoute","ui.bootstrap"]

coffeeshop.config ($routeProvider)->
		$routeProvider.when('/', {templateUrl:'store', controller:"store"})
		$routeProvider.when('/admin', {templateUrl:'admin', controller:"admin"})
		$routeProvider.when('/modal', {templateUrl:'modal', controller:"admin"})
		$routeProvider.when('/entity/list', {templateUrl:'entity/list', controller:"admin"})
		$routeProvider.when('/pretty', {templateUrl:'pretty', controller:"admin"})
		$routeProvider.when('/products', {templateUrl:'products/list', controller:"admin"})
		$routeProvider.when('/product/cart', {templateUrl:'products/cart', controller:"admin"})
		$routeProvider.when('/product/edit', {templateUrl:'products/edit'})
		$routeProvider.when('/product/:productId', {templateUrl:'products/detail', controller:"productDetail"})
		$routeProvider.when('/attachment/edit', {templateUrl:'attachments/edit', controller:"attachmentEditor"})
		$routeProvider.when('/attachment/list', {templateUrl:'attachments/list', controller:"admin"})
		$routeProvider.when('/picture/upload', {templateUrl:'pictures/upload', controller:"pictureUploader"})
		$routeProvider.when('/picture/list', {templateUrl:'pictures/list', controller:"pictureList"})
		$routeProvider.when('/picture/gallery', {templateUrl:'pictures/gallery', controller:"pictureGallery"})
		.otherwise({redirectTo: '/'})

module.exports = coffeeshop

require "./store/controller.coffee"
require "./admin/controller.coffee"
require "./pretty/directive.coffee"

require "./modal/controller.coffee"
require "./modal/directive.coffee"

require "./entity/list/directive.coffee"

require "./storage/service.coffee"
require "./uploader/service.coffee"

require "./products/list/controller.coffee"
require "./products/list/directive.coffee"

require "./products/detail/directive.coffee"

require "./products/edit/directive.coffee"

require "./products/cart/directive.coffee"

require "./categories/list/directive.coffee"

require "./attachments/edit/controller.coffee"
require "./attachments/edit/directive.coffee"

require "./attachments/list/controller.coffee"
require "./attachments/list/directive.coffee"

require "./pictures/upload/controller.coffee"
require "./pictures/upload/directive.coffee"

require "./pictures/list/controller.coffee"
require "./pictures/list/directive.coffee"

require "./pictures/gallery/controller.coffee"
require "./pictures/gallery/directive.coffee"
