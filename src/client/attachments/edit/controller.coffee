angular.module('coffeeshop').controller "attachmentEditor", ($scope, storage)->
	#Only works for a new attachment.
	$scope.currentAttachment = {}
	storage.ready.then (products)->
		$scope.currentAttachment = storage.build "Attachment", {}
