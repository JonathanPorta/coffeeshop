angular.module('coffeeshop').directive "categoryNav", ($templateCache)->
		restrict: "A"
		scope: {
			entities: "="
			initialSelection: "="
			onSelectionChange: "&"
			params: "@"
			onCreateNew: "&"
			parentSelection: "="
			currentCategory: "="
		}
		templateUrl: "categories/accordion/widget"
		replace: false
		transclude: false
		controller: ($scope, storage, $filter)->
			console.log "entityList Directive - Controller Function"
			#Default config options
			defaults = {
				"image": "thumbnail" #false, thumbnail, medium, large, full - options for images
				"searchOn": false #entity key or false to disable
				"multiselect": false
				"manageSelection": true #If false, we don't track what is/isn't selected. We point it toward the initialSelection parameter if it is set, otherwise, forget it. Go home early.
				"title": false
				"compact": false
				"defaultFilter":null
				"filters": []
				"allowNav": true
				"placeholder":
					"thumbnail": "/placeholder/thumbnail"
					"medium"   : "/placeholder/medium"
					"large"    : "/placeholder/large"
					"fullsize" : "/placeholder/fullsize"
				"imgClass" : ""
				"newButton" : false #string label, or false
				"editButton" : false #defaults to same as newButton. This is only the label of the button.
			}

			#Setup for the override
			params = {}
			if $scope.params
				params = JSON.parse($scope.params)

			#Override defaults
			for opt, val of params
				defaults[opt] = val
			$scope.config = defaults

			$scope.searchCriteria = ""
			$scope.currentFilter = $scope.config.defaultFilter
			if $scope.config.newButton && !$scope.config.editButton
				$scope.config.editButton = $scope.config.newButton

			#The selected entities will be added here.
			#In multiselect mode, this array may contain more than one entity.
			#If not multiselect, this will contain at most one entity, duh!
			if $scope.initialSelection
				$scope.selection = $scope.initialSelection
			else
				$scope.selection = []

			if $scope.config.manageSelection
				$scope.$watch 'entities', ()->
					#If the entities changed, we prob need to bail on our selection, right?
					$scope.selection = []

			#Currently selected filter params are stored here
			filterParams = {}
			$scope.doFiltering = ()->
				if $scope.config.searchOn
					filterParams[$scope.config.searchOn] = $scope.searchCriteria
				if $scope.currentFilter
					filterParams[$scope.currentFilter.key] = $scope.currentFilter.value
				$scope.filteredEntities = $filter('filter')($scope.entities, filterParams)

			#watch for changes in the entities and the filter in order to trigger filtering
			$scope.$watch "entities", $scope.doFiltering
			$scope.$watch "currentFilter", $scope.doFiltering
			$scope.$watch "searchCriteria", $scope.doFiltering

			if $scope.config.manageSelection
				#Add initial selection to the current selection.
				if $scope.initialSelection
					for selected in $scope.initialSelection
						$scope.selection.push selected

			#Fired when clicking the new/add button
			$scope.createNew = ()->
				console.log "entityList Directive - createNew() Called!"
				$scope.onCreateNew()

			#Nothing like a description that just won't shutup! Nowhamsayin?
			$scope.trimIt = (str, length = 100)->
				str.substring 0, length

			#Figure out which image to give the list for a given entity
			$scope.getImage = (entity)->
				if $scope.config.image
					src = $scope.config.placeholder[$scope.config.image]
					if entity._type() == "Picture"
						src = entity[$scope.config.image]
					else if entity.pictures.length > 0
						src = entity.pictures[0][$scope.config.image]
					src

			$scope.buildUrl = (category)->
				url = ""
				if $scope.config.allowNav
					url = "#/category/"+category.category_id
				url

			$scope.makeSelection = (entity)->
				if typeof $scope.onSelectionChange is "function"
					console.log "entityList Directive - Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSelectionChange({"selection":entity})

