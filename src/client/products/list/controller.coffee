angular.module('coffeeshop').controller "productList", ($scope, storage)->
	$scope.products = []

	watchExp = (entity)->
		lastModified = 0
		entity.on 'modified', ->
			lastModified = new Date / 1e3
		-> lastModified

	save = (newV, oldV) ->
		storage.save()
	storage.ready.then (products)->
		console.log "then", products
		$scope.products = products
		#$scope.$watch watchExp(list), save, true
		#$scope.$watch "list._status() != 'PERSISTED'", save, true

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
		#console.log "finally", e
		storage.save()
