angular.module('coffeeshop').controller "admin", ($scope, storage, $modal)->
	$scope.categories = []
	$scope.products   = []

	$scope.selectedProduct    = null
	$scope.selectedAttachment = null
	$scope.selectedCategory   = null
	$scope.selectedPicture    = null

	$scope.relatedProducts    = []
	$scope.relatedAttachments = []
	$scope.relatedCategories  = []
	$scope.relatedPictures    = []

	watchExp = (entity)->
		lastModified = 0
		entity.on 'modified', ->
			lastModified = new Date / 1e3
		-> lastModified

	$scope.onCreateNewAttachment = ()->
		if $scope.selectedAttachment
			console.log "Editing and Attachment"
			selectedAttachment = $scope.selectedAttachment
		else
			console.log "Making a new Attachment!"
			selectedAttachment = storage.build "Attachment", {}

		cb = (att)->
			$scope.onNewAttachment(att)

		console.log "adminCtrl :: onCreateNewAttachment", $scope.selectedAttachment
		newAttachmentDialogCtrl = ($scope, $modalInstance)->
			console.log "This is the controller of the modal! yay!"
			$scope.currentAttachment = selectedAttachment
			$scope.close = (e)->
				cb($scope.currentAttachment)
				$modalInstance.close(e)

		newAttachmentDialog = $modal.open({
			templateUrl: "attachments/edit/modal"
			backdrop: true
			keyboard: true
			controller: newAttachmentDialogCtrl
		})
		console.log newAttachmentDialog

	$scope.onCreateNewPicture = ()->
		if $scope.selectedPicture
			console.log "Editing a Picture"
			selectedPicture = $scope.selectedPicture
		else
			console.log "Making a new Picture!"
		cb = (pic)->
			$scope.addPicture(pic)

		console.log "adminCtrl :: onCreateNewPicture"
		newPictureDialogCtrl = ($scope, $modalInstance)->
			console.log "This is the controller of the modal! yay!"
			$scope.close = (entity)->
				$modalInstance.close()
				cb(entity)

		newPictureDialog = $modal.open({
			templateUrl: "pictures/upload/modal"
			backdrop: true
			keyboard: true
			controller: newPictureDialogCtrl
		})
		console.log newPictureDialog

	$scope.newProduct = ->
		$scope.selectedProduct = storage.build "Product", {}

	$scope.onSelectCategory = (cat)->

	$scope.onSelectMainProduct = (prod)->
		console.log "Admin Controller - Main Product Selected", prod
		$scope.selectedProduct = prod
		$scope.relatedPictures = prod.pictures
		$scope.relatedAttachments = prod.attachments
		$scope.relatedCategories = []
		$scope.relatedCategories.push prod.category

	$scope.onSelectAttachment = (att)->
		console.log "Admin Controller - Attachment Selected", att
		$scope.selectedAttachment = att

	$scope.onNewAttachment = (att)->
		console.log "Admin Controller - New Attachment Selected", att
		att.product = $scope.selectedProduct
		$scope.selectedAttachment = att
		$scope.onRelatedAttachmentsChange $scope.selectedProduct.attachments
		save att
		save $scope.selectedProduct

	$scope.onRelatedProductsChange = (prods)->
		console.log "Admin Controller - Related Products Changed!", prods
		$scope.relatedProducts = prods

	$scope.onRelatedAttachmentsChange = (atts)->
		console.log "Admin Controller - Related Attachments Changed!", atts
		$scope.relatedAttachments = atts
		$scope.onSelectAttachment atts[0]

	$scope.onRelatedCategoriesChange = (cats)->
		console.log "Admin Controller - Related Categories Changed!", cats
		$scope.relatedCategories = prods

	$scope.addPicture = (pic)->
		console.log "Adding a new pic to the pile and current product: ", pic
		pic.product = $scope.selectedProduct
		$scope.relatedPictures = $scope.selectedProduct.pictures
		save $scope.selectedProduct
		save pic

	save = (entity) ->
		#need to make saving smarter so we don't have tons of persists.
		entities = [entity]
		storage.save(entities)

	storage.ready.then (data)->
		console.log "Admin Controller - Storage Ready", data
		$scope.products = data.products
		$scope.categories = data.categories
#		$scope.onRelatedAttachmentsChange data.attachments
#		$scope.relatedPictures = data.pictures
		#$scope.$watch watchExp(list), save, true
		#$scope.$watch "list._status() != 'PERSISTED'", save, true

	storage.ready.catch (e)->
		console.log "Admin Controller - Storage Error", e

	storage.ready.finally (e)->
		#console.log "finally", e
		storage.save()
