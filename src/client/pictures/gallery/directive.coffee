angular.module('coffeeshop').directive "pictureGallery", ()->
		restrict: "A"
		scope: {
			pictures: "="
			initialSelection: "="
			onSelectionChange: "&"
			onCreateNew: "&"
			params: "@"
		}
		templateUrl: "pictures/gallery/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
			console.log "pictureGallery Directive - Link Function!"
			console.log( scope, element, attrs, controller )
		controller: ($scope, storage)->
			console.log "pictureGallery Directive - Controller Function"

			#Default config options
			defaults = {
				"title": false
				"compact": false
			}

			#Setup for the override
			params = {}
			if $scope.params
				params = JSON.parse($scope.params)

			#Override defaults
			for opt, val of params
				defaults[opt] = val
			$scope.config = defaults

			$scope.createNew = ()->
				console.log "pictureGallery Directive - createNew() Called!"
				$scope.onCreateNew()

			#The selected entities will be added here.
			#In multiselect mode, this array may contain more than one entity.
			#If not multiselect, this will contain at most one entity, duh!
			$scope.selection = null

			$scope.$watch 'pictures', ()->
				if $scope.pictures.length > 0
					#set the first image to the selected
					$scope.makeSelection $scope.pictures[0]
				else
					#we dont have pics, so need to remove any left overs
					$scope.selection = null

			$scope.makeSelection = (entity)->
				console.log "pictureGallery Directive - makeSelection() Called!", entity, $scope.selection
				#set the selection
				$scope.selection = entity
				#Is it required to check if this is a function? I think angular might take care of this for us.
				#because I think it wraps it in a function anways resulting in a noop if not specified.
				if typeof $scope.onSelectionChange is "function"
					console.log "pictureGallery Directive - Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSelectionChange({"selection":$scope.selection})
