angular.module('coffeeshop').directive "entityList", ($templateCache)->
		restrict: "A"
		scope: {
			entities: "="
			initialSelection: "="
			onSelectionChange: "&"
			params: "@"
		}
		templateUrl: "entity/list/widget"
		replace: true
		transclude: false
		compile: (element, attributes, transclude)->
			##Compile
			listviewTemplate = attributes.listviewTemplate
			element.find(".list-body").before $templateCache.get listviewTemplate
			element.find(".list-body").detach()

			(scope, instanceElement, instanceAttributes, ctrl, tc)->
				##Link

		controller: ($scope, storage, $filter)->
			console.log "entityList Directive - Controller Function"
			#Default config options
			defaults = {
				"image": "thumbnail" #false, thumbnail, medium, large, full - options for images
				"searchOn": false #entity key or false to disable
				"multiselect": false
				"title": false
				"compact": false
				"defaultFilter":null
				"filters": []
				"placeholder":
					"thumbnail": "/placeholder/thumbnail"
					"medium"   : "/placeholder/medium"
					"large"    : "/placeholder/large"
					"fullsize" : "/placeholder/fullsize"
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

			#The selected entities will be added here.
			#In multiselect mode, this array may contain more than one entity.
			#If not multiselect, this will contain at most one entity, duh!
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

			#Add initial selection to the current selection.
			if $scope.initialSelection
				for selected in $scope.initialSelection
					$scope.selection.push selected

			#Nothing like a description that just won't shutup! Nowhamsayin?
			$scope.trimIt = (str, length = 100)->
				str.substring 0, length

			$scope.getImage = (entity)->
				if $scope.config.image
					src = $scope.config.placeholder[$scope.config.image]
					if entity._type() == "Picture"
						src = entity[$scope.config.image]
					else if entity.pictures.length > 0
						src = entity.pictures[0][$scope.config.image]
					src

			#This is what will be triggered when someone clicks on an entity in the list.
			#In multiselect mode, we check to see if entity is in the selection already. If so, it is removed.
			##If not, we add it. Then pass the array to the callback.
			#In single select mode, we set selection[0] to the entity, not caring if it is already selected.
			##Then we pass just the entity to the callback, because we are nice like that.
			$scope.makeSelection = (entity)->
				console.log "entityList Directive - makeSelection() Called!", entity, $scope.selection

				if $scope.config.multiselect
					console.log "entityList Directive - we are a multiselect!"
					if entity not in $scope.selection
						$scope.selection.push entity
						console.log "entityList Directive - adding to selection!"
					else
						i = $scope.selection.indexOf entity
						$scope.selection.splice(i, 1)
						console.log "entityList Directive - removing from selection!"
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

				console.log "entityList Directive - we will be returning: ", toReturn

				#Is it required to check if this is a function? I think angular might take care of this for us.
				#because I think it wraps it in a function anways resulting in a noop if not specified.
				if typeof $scope.onSelectionChange is "function"
					console.log "entityList Directive - Oh! Callback exists! Wooty tooty juicy and fruity or something..."
					$scope.onSelectionChange({"selection":toReturn})
