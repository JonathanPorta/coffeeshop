angular.module('coffeeshop').controller "attachmentList", ($scope, storage)->
	$scope.attachments = [{"title":"asd"},{"title":"asd"},{"title":"asd"},{"title":"asd"},{"title":"sad"},{"title":"asd"}]

	watchExp = (entity)->
		lastModified = 0
		entity.on 'modified', ->
			lastModified = new Date / 1e3
		-> lastModified

	save = (newV, oldV) ->
		storage.save()

#	storage.ready.then (data)->
#		$scope.attachments = data.attachments
#		console.log "attachmentList Controller - Got Attachments: ", $scope.attachments
#		#$scope.$watch watchExp(list), save, true
#		#$scope.$watch "list._status() != 'PERSISTED'", save, true

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
		#console.log "finally", e
		storage.save()
