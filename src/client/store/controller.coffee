angular.module('coffeeshop').controller "store", ($scope, storage, $routeParams, $filter)->

	console.log "ROUTEPARAMS: ", $routeParams
	$scope.galleryview = false

	state = {
		product_id  : ""
		category_id : ""
	}

	if $routeParams.hasOwnProperty "category_id"
		state.category_id = $routeParams['category_id']

	if $routeParams.hasOwnProperty "product_id"
		state.product_id = $routeParams['product_id']

	$scope.categories = []
	$scope.products = []
	$scope.selectedCategory = ""
	$scope.selectedProduct = ""
	$scope.relatedProducts = []
	$scope.productPictures = []
	$scope.productAttachments = []

	$scope.attributes = []
	$scope.externals = []
	$scope.parentCategories = []

	watchExp = (entity)->
		lastModified = 0
		entity.on 'modified', ->
			lastModified = new Date / 1e3
		-> lastModified

	$scope.getAttributes = ()->
		$scope.attributes = $filter("attr") $scope.productAttachments, ["attribute"]

	$scope.getExternals = ()->
		$scope.externals = $filter("attr") $scope.productAttachments, ["link","download","video"]

	$scope.reset = ()->
		$scope.selectedProduct = ""
		$scope.relatedProducts = []
		$scope.productPictures = []
		$scope.productAttachments = []

	$scope.onSelectCategory = (cat)->
		$scope.selectedCategory = cat
		$scope.products = cat.products
		$scope.reset()

	$scope.onSelectProduct = (prod)->
		$scope.selectedProduct = prod
		$scope.selectedCategory = prod.category
		$scope.onRelatedProductsChange()
		$scope.onProductPicturesChange()
		$scope.onAttachmentsChange()

	$scope.onRelatedProductsChange = ()->
		console.log "Store Controller - Related Products Changed!"
		storage.getRelatedProducts($scope.selectedProduct)
		.then (related)->
			console.log "Store Controller - Got Related Prods!", related
			$scope.relatedProducts = related
		.catch (err)->
			console.log "Error getting those related products", err

	$scope.onAttachmentsChange = ()->
		console.log "Store Controller - Attachments Changed!"
		storage.getProductAttachments($scope.selectedProduct)
		.then (atts)->
			console.log "Store Controller - Got Attachments!", atts
			$scope.productAttachments = atts
			$scope.getAttributes()
			$scope.getExternals()
		.catch (err)->
			console.log "Error getting those related products", err

	$scope.onProductPicturesChange = ()->
		console.log "Store Controller - Product Pictures Changed!"
		storage.getProductPictures($scope.selectedProduct)
		.then (pics)->
			console.log "Store Controller - Got Prod Pics!", pics
			$scope.productPictures = pics
		.catch (err)->
			console.log "Error getting those related products", err

	save = (newV, oldV) ->
		storage.save()

	storage.ready.then (d)->
		if state.product_id
			storage.getProduct(state.product_id)
			.then (data)->
#				$scope.categories = data.all_categories
				$scope.onSelectProduct data.product
		else if state.category_id
			storage.getProductsByCategory(state.category_id)
			.then (data)->
#				$scope.categories = data.all_categories
				$scope.onSelectCategory data.category
		storage.getParentCategories()
				.then (data)->
					$scope.categories = data.categories
					$scope.parentCategories = data.categories

		console.log "then", d
#		$scope.products = data.products
#		$scope.categories = data.categories
		#$scope.$watch watchExp(list), save, true
		#$scope.$watch "list._status() != 'PERSISTED'", save, true

	storage.ready.catch (e)->
		console.log "error", e

	storage.ready.finally (e)->
		#console.log "finally", e
		storage.save()
