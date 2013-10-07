$scope = null
loadScope = inject ($rootScope, $controller)->
	$scope = $rootScope.$new()
	$controller "productList", {$scope}

describe "productList controller", ->
	beforeEach module "coffeeshop"
	beforeEach loadScope
	afterEach -> delete window.localStorage.clear()   #######THIS MIGHT BE DESTRUCTIVE.....SHRUG.....SHRUG!

	it "exposes products", ->
		expect($scope.products).toEqual([], "products should be array")
