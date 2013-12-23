angular.module('coffeeshop').directive "bsDialog", ($compile)->
	restrict: "A"
	scope: {}
	templateUrl: "modal/widget"
	replace: true
	transclude: true
	#Grab the first child, a button, and bind some clickity.
	#Grab the contents of the div with class .dialog-modal-title, that's our, wait for it, title.
	#grab the contents of the div with the class .dialog-modal-contents, that's our, well, I bet you can guess...
	compile: (element, attributes, transclude)->
		(scope, instanceElement, instanceAttributes, ctrl, tc)->
			clickHandler = (e)->
				scope.open e
			tc scope, (clone)->
				#Find our stuffs
				btn = clone[0]
				header = clone[1]
				content = clone[2]
				footer = clone[3]
				#place our stuffs
				element.find(".modal-header>h3").html header.innerHTML
				element.find(".modal-body").html $compile(content.innerHTML)(scope.$parent)
				element.find(".modal-footer").html footer.innerHTML
				#bind click handler
				angular.element(btn).bind 'click', clickHandler
				#Place button in DOM near original directive launch.
				element.before btn

	controller: ($scope, $element, $attrs, $transclude)->

		console.log "modal Directive - Controller Function"
		console.log $scope, $element, $attrs, $transclude

		#Start with no modal, work our ways uuup!
		$scope.modal = null

		#Register Events
		$scope.onOpen = ()->
			console.log "onOpen() fired!"
			$scope.modal = true
		$scope.onClose = ()->
			console.log "onClose() fired!"
		$scope.onSelection = (data)->
			$scope.close()
			console.log "onSelection() fired!", data

		$scope.open = (e)->
			console.log "open() fired!",e
			if $scope.modal
				$element.modal 'show'
				console.log "Show"
			else
				$element.modal()
				$scope.register()
				console.log "New Modal"

		$scope.close = (e)->
			console.log "close() fired!",e
			if $scope.modal
				$element.modal 'hide'
				console.log "Hide"

		$scope.register = ()->
			$element.on 'hidden.bs.modal', $scope.onClose
			$element.on 'shown.bs.modal', $scope.onOpen
			$scope.$parent.$parent.currentModalInterface = {
				#this should de-register itself after it closes...Still..should be a service.
				close: ()->
					console.log "currentModalInterface::close - from modal"
					$scope.close()
				open: ()->
					console.log "currentModalInterface::open - from modal"
					$scope.open()
			}





		#	link: (scope, element, attrs, controller, transclude)->
#		console.log "modal Directive - Link Function!"
#		console.log scope, element, attrs, controller, transclude
#		transclude (clone)->
#			console.log "Transclude - Orig", clone
#			console.log "Transclude - New", element
