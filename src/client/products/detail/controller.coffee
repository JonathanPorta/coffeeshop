angular.module('coffeeshop').controller "productDetail", ($scope, storage, $routeParams)->
	$scope.product = null
	$scope.productId = $routeParams.productId
	console.log "product id: ", $routeParams.productId

	storage.ready.then (products)->
		#storage.find "Product", $scope.productId

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
#		console.log "finally", e
