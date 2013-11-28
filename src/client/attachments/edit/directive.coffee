angular.module('coffeeshop').directive "attachmentEdit", ()->
	{
		restrict: "A"
		scope: {
			currentAttachment: "="
			onSave: "&"
		}
		templateUrl: "attachments/edit/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
#			scope.$watch "products", (update, old)->
#				console.log "Products updated!", old, update

			console.log "attachmentEdit Directive Link Function!"
			console.log( scope, element, attrs, controller )
		controller: ($scope, storage)->
			console.log "attachmentEdit Directive ctrl"
			$scope.save = ()->
				console.log "save() Called!"
				console.log $scope.currentAttachment
				if typeof $scope.onSave is "function"
					console.log "Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSave $scope.currentAttachment
	}
