$scope = null
loadScope = inject ($rootScope, $controller)->
	$scope = $rootScope.$new()
	$controller "productDetail", {$scope}

describe "productDetail controller", ->
	beforeEach module "coffeeshop"
	beforeEach loadScope
	afterEach -> delete window.localStorage.clear()   #######THIS MIGHT BE DESTRUCTIVE.....SHRUG.....SHRUG!

	it "exposes product", ->
		expect($scope.product).toEqual(null, "product should be null")
