angular.module('coffeeshop').controller "store", ($scope, storage)->
	$scope.categories = []
	$scope.products = []
	$scope.selectedCategory = ""
	$scope.selectedProduct = ""

	watchExp = (entity)->
		lastModified = 0
		entity.on 'modified', ->
			lastModified = new Date / 1e3
		-> lastModified

	$scope.onSelectCategory = (cat)->
		$scope.selectedCategory = cat
		$scope.products = cat.products
		$scope.selectedProduct = ""

	$scope.onSelectProduct = (prod)->
		$scope.selectedProduct = prod

	save = (newV, oldV) ->
		storage.save()

	storage.ready.then (data)->
		console.log "then", data
		$scope.products = data.products
		$scope.categories = data.categories
		#$scope.$watch watchExp(list), save, true
		#$scope.$watch "list._status() != 'PERSISTED'", save, true

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
		#console.log "finally", e
		storage.save()
