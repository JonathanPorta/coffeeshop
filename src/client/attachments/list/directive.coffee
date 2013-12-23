angular.module('coffeeshop').directive "attachmentList", ()->
	{
		restrict: "A"
		scope: {
			attachments: "="
			initialSelection: "="
			onSelectionChange: "&"
			onCreateNew: "&"
			params: "@"
		}
		templateUrl: "attachments/list/widget"
		replace: true
		transclude: false
		link: (scope, element, attrs, controller)->
#			scope.$watch "attachments", (update, old)->
#				console.log "Attachments updated!", old, update

			console.log "attachmentList Directive - Link Function!"
			console.log( scope, element, attrs, controller )
		controller: ($scope, storage)->
			console.log "attachmentList Directive - Controller Function"

			#Default config options
			defaults = {
				"multiselect": false
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

			#The selected entities will be added here.
			#In multiselect mode, this array may contain more than one entity.
			#If not multiselect, this will contain at most one entity, duh!
			$scope.selection = []

			#Add initial selection to the current selection.
			if $scope.initialSelection
				for selected in $scope.initialSelection
					$scope.selection.push selected

			$scope.createNew = ()->
				console.log "attachmentList Directive - createNew() Called!"
				$scope.onCreateNew()

			#This is what will be triggered when someone clicks on an entity in the list.
			#In multiselect mode, we check to see if entity is in the selection already. If so, it is removed.
			##If not, we add it. Then pass the array to the callback.
			#In single select mode, we set selection[0] to the entity, not caring if it is already selected.
			##Then we pass just the entity to the callback, because we are nice like that.
			$scope.makeSelection = (entity)->
				console.log "attachmentList Directive - makeSelection() Called!", entity, $scope.selection

				if $scope.config.multiselect
					if entity not in $scope.selection
						$scope.selection.push entity
						console.log "attachmentList Directive - adding to selection!"
					else
						i = $scope.selection.indexOf entity
						$scope.selection.splice(i, 1)
						console.log "attachmentList Directive - removing from selection!"
					toReturn = $scope.selection
				else
					if $scope.selection[0] == entity
						i = $scope.selection.indexOf entity
						$scope.selection.splice(i, 1)
						toReturn = null
						console.log "attachmentList Directive - unselected"
					else
						$scope.selection[0] = entity
						console.log "attachmentList Directive - we are a single select..."
						toReturn = entity

				console.log "attachmentList Directive - we will be returning: ", toReturn

				#Is it required to check if this is a function? I think angular might take care of this for us.
				#because I think it wraps it in a function anways resulting in a noop if not specified.
				if typeof $scope.onSelectionChange is "function"
					console.log "attachmentList Directive - Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSelectionChange({"selection":toReturn})
	}
