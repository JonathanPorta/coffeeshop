angular.module('coffeeshop').controller "productDetail", ($scope, storage)->
	$scope.product = null

	storage.ready.then (products)->
		$scope.product = products[0]

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
		console.log "finally", e
