angular.module('coffeeshop').directive "categoryEdit", ()->
	restrict: "A"
	scope: {
		category: "="
		save: "&"
		params: "@"
		parentCategories: "="
	}
	templateUrl: "categories/edit/widget"
	replace: true
	transclude: false
	link: (scope, element, attrs, controller)->
		console.log "categoryEdit Directive - Link Function!"
		console.log scope, element, attrs, controller
	controller: ($scope)->
		console.log "categoryEdit Directive - Controller Function!"

		#Default config options
		defaults = {
			"title": false
		}

		#Setup for the override
		params = {}
		if $scope.params
			params = JSON.parse($scope.params)

		#Override defaults
		for opt, val of params
			defaults[opt] = val
		$scope.config = defaults

		#Can't set the parent to itself.
		$scope.filterParents = () ->
			if $scope.category
				$scope.parents = []
				$scope.parent_id = $scope.category.parent_id
				for parent in $scope.parentCategories
					if parent.category_id != $scope.category.category_id
						$scope.parents.push parent

		$scope.$watch "parentCategories", $scope.filterParents
		$scope.$watch "category", $scope.filterParents

		$scope.onSave = ()->
			console.log "categoryEdit Directive - Save Function!", $scope.category
			$scope.save()
