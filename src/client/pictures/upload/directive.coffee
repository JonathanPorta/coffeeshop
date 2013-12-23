angular.module('coffeeshop').directive "fileChange", ()->
	restrict: "A"
	link: (scope, element, attrs, controller)->
		console.log "fileChange Directive Link Function!"
		console.log( scope, element, attrs, controller )
		element.bind "change", ->
			scope.$apply ->
				scope[attrs['fileChange']](element[0].files)

angular.module('coffeeshop').directive "pictureUpload", ()->
	restrict: "A"
	scope: {
		onComplete: "&"
		onSave: "&"
		
	}
	templateUrl: "pictures/upload/widget"
	replace: true
	transclude: false
	link: (scope, element, attrs, controller)->
		console.log "pictureUpload Directive Link Function!"
		console.log( scope, element, attrs, controller )
	controller: ($scope, storage, uploader)->
		console.log "pictureUpload Directive ctrl"
		$scope.name = ""
		$scope.doUpload = (files)->
			console.log "doUpload called!"
			console.log files
			entitySpec = {
				name : $scope.name
			}
			storage.upload(files, entitySpec)
			.then (entity)->
				console.log "File Upload Success", entity
				$scope.newPic = entity
				$scope.onComplete({"entity":entity})
			.catch (err)->
				console.log "File Upload FAIL!", err

		$scope.save = ()->
			if typeof $scope.onSave is "function"
				console.log "Oh! Callback exists! Wooty tooty juicy and fruity or something..."
				$scope.onSave({"entity":$scope.newPic})
