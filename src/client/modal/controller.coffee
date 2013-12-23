angular.module('coffeeshop').controller "modal", ($scope)->
	console.log "modal Controller...Crickets..."

	$scope.onSelection = (maybe)->
		console.log "modal Controller - onSelection called: ", maybe
