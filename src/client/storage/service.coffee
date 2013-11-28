angular.module('coffeeshop').service "storage", ($location, $q, $rootScope)->
	products = null

	base = "#{$location.protocol()}://#{$location.host()}:#{$location.port()}/"
	runtime = new JEFRi.Runtime "#{base}context.json"
	loading = $q.defer()

	storage =
		get: ->
		save: ->
		build: ->
		runtime: runtime
		ready: loading.promise
		samples: [
			{'status':'active', 'name':'Helicopter', 'description':'', 'sku':'', 'partno':''}
			{'status':'active', 'name':'Racecar', 'description':'', 'sku':'', 'partno':''}
			{'status':'active', 'name':'Quadcopter', 'description':'', 'sku':'', 'partno':''}
			{'status':'pending', 'name':'Race Track', 'description':'', 'sku':'', 'partno':''}
			{'status':'active', 'name':'Train Track', 'description':'', 'sku':'', 'partno':''}
			{'status':'hidden', 'name':'Train Engine', 'description':'', 'sku':'', 'partno':''}
			{'status':'active', 'name':'Beginner Airplane', 'description':'', 'sku':'', 'partno':''}
			{'status':'pending', 'name':'Expensive Radio', 'description':'', 'sku':'', 'partno':''}
			{'status':'hidden', 'name':'Cheap Radio', 'description':'', 'sku':'', 'partno':''}
			{'status':'active', 'name':'Small Propellor', 'description':'', 'sku':'', 'partno':''}
			{'status':'hidden', 'name':'Medium Propellor', 'description':'', 'sku':'', 'partno':''}
			{'status':'active', 'name':'Large Propellor', 'description':'', 'sku':'', 'partno':''}
		]

	runtime.ready.then ->
		t = new window.JEFRi.Transaction()
		t.add _type: 'Product'
		s = new window.JEFRi.Stores.PostStore({remote: base, runtime})

		s.execute('get', t)
		.then (list)->
			if list.entities.length
				runtime.expand list.entities
				products = runtime.find('Product')
			else
				throw new Exception 'Product not found.'
		.catch (e)->
			products = (runtime.build "Product", product for product in storage.samples)
		.finally ->
			storage.get = -> products
			storage.save = ->
				t = new window.JEFRi.Transaction()
				t.add product for product in products
				s = new window.JEFRi.Stores.PostStore({remote: base, runtime})
				s.execute 'persist', t
			storage.build = (type, initial = {})->
				runtime.build(type, initial)

			loading.resolve products # Why doesn't resolving $q trigger a digest?
			$rootScope.$digest()
			
	.catch (e)->
		console.error "Couldn't load context!"
		console.error e.message, e
	storage
