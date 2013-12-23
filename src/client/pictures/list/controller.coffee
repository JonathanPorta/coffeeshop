angular.module('coffeeshop').controller "pictureList", ($scope, storage)->
	$scope.pictures = []
	$scope.selectedPicture = null

	watchExp = (entity)->
		lastModified = 0
		entity.on 'modified', ->
			lastModified = new Date / 1e3
		-> lastModified

	$scope.onSelectPicture = (pic)->
		$scope.selectedPicture = pic
		console.log "Pic selected!", pic

	save = (newV, oldV) ->
		storage.save()
	storage.ready.then (data)->
		console.log "then", data
		$scope.pictures = data['pictures']
		#$scope.$watch watchExp(list), save, true
		#$scope.$watch "list._status() != 'PERSISTED'", save, true

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
		#console.log "finally", e
		storage.save()
