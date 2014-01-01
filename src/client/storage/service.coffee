angular.module('coffeeshop').service "storage", (uploader, $location, $q, $rootScope)->
	products = null
	categories = null
	attachments = null
	pictures = null

	base = "#{$location.protocol()}://#{$location.host()}:#{$location.port()}/"
	runtime = new JEFRi.Runtime "#{base}context.json"
	loading = $q.defer()

	storage =
		get: ->
		save: ->
		build: ->
		runtime: runtime
		ready: loading.promise
		lorem: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
		samples:
			"Helicopters":[
				{'status':'active', 'name':'Helicopter', 'sku':'3216654', 'partno':'ASD-454', 'description':''}
				{'status':'active', 'name':'Quadcopter', 'sku':'6546545', 'partno':'ASD-454', 'description':''}
			]
			"Racing":[
				{'status':'active', 'name':'Racecar', 'sku':'5816788', 'partno':'ASD-454', 'description':''}
				{'status':'pending', 'name':'Race Track', 'sku':'6598185', 'partno':'ASD-454', 'description':''}
			]
			"Trains":[
				{'status':'active', 'name':'Train Track', 'sku':'7586258', 'partno':'ASD-454', 'description':''}
				{'status':'hidden', 'name':'Train Engine', 'sku':'9685268', 'partno':'ASD-454', 'description':''}
			]
			"R/C Plains":[
				{'status':'active', 'name':'Beginner Airplane', 'sku':'1498358', 'partno':'ASD-454', 'description':''}
				{'status':'pending', 'name':'Expensive Radio', 'sku':'5625458', 'partno':'ASD-454', 'description':''}
				{'status':'hidden', 'name':'Cheap Radio', 'sku':'8952457', 'partno':'ASD-454', 'description':''}
			]
			"Parts":[
				{'status':'active', 'name':'Small Propellor', 'sku':'9845877', 'partno':'ASD-454', 'description':''}
				{'status':'hidden', 'name':'Medium Propellor', 'sku':'9856787', 'partno':'ASD-454', 'description':''}
				{'status':'active', 'name':'Large Propellor', 'sku':'2145689', 'partno':'ASD-454', 'description':''}
			]

	runtime.ready.then ->
		t = new window.JEFRi.Transaction()
#		t.add _type: 'Product'
		t.add _type: 'Category'
#		t.add _type: 'Picture'
#		t.add _type: 'Attachment'
		s = new window.JEFRi.Stores.PostStore({remote: base, runtime})

		s.execute('get', t)
		.then (list)->
			if list.entities.length
				runtime.expand list.entities
				products = runtime.find('Product')
				if not products.length
					throw new Exception 'Products not found.'
			else
				throw new Exception 'Product not found.'
		.catch (e)->
			console.log "Storage Exception Caught: ", e
#			categories = []
#			products = []
#			for categoryName, products of storage.samples
#				cat = runtime.build "Category", {"name":categoryName}
##				categories.push cat
#				for product in products
#					prod = runtime.build "Product", product
#					prod.category = cat
#					prod.description = storage.lorem
#					attach = runtime.build "Attachment", {"type":"download","title":"User Guide","value":"http://dlnmh9ip6v2uc.cloudfront.net/datasheets/Dev/Beagle/4DCAPE-70T_datasheet_R_1_0.pdf"}
#					console.log "new attach: ", attach
#					prod.attachment = attach
##					products.push prod
##			products = (runtime.build "Product", product for product in storage.samples.Product)
##			categories = (runtime.build "Category", cat for cat in storage.samples.Category)
		.finally ->
			products = runtime.find "Product"
			categories = runtime.find "Category"
			attachments = runtime.find "Attachment"
			pictures = runtime.find "Picture"
			storage.get = (type, params = {})->
				getting = $q.defer()
				params['_type'] = type
				t = new window.JEFRi.Transaction()
				t.add params
				s.execute('get', t)
				.then (trans)->
					if trans.entities.length
						runtime.expand trans.entities
						getting.resolve trans.entities
					else
						getting.resolve []
				.catch (err)->
					console.log "Failed to get: " , params, err
					getting.reject err
				getting.promise
			storage.save = (entities = [])->
				t = new window.JEFRi.Transaction()
				if entities.length
					t.add entity for entity in entities
				else
					t.add product for product in products
					t.add category for category in categories
				s = new window.JEFRi.Stores.PostStore({remote: base, runtime})
				s.execute 'persist', t
			storage.build = (type, initial = {})->
				runtime.build(type, initial)
			storage.getRelatedProducts = (prod)->
				related = $q.defer()
				if prod.relatedProducts
					relatedProdIds = JSON.parse prod.relatedProducts
					t = new window.JEFRi.Transaction()
					for id in relatedProdIds
						t.add {_type:"Product", "product_id":id}
					s.execute('get', t)
					.then (results)->
						console.log "Related Prods", results
						related.resolve results.entities
					.catch (err)->
						console.log "error getting related", err
				else
					console.log "Returning empty array for related prods"
					related.resolve []
				related.promise
			storage.getProductPictures = (prod)->
				pics = $q.defer()

				t = new window.JEFRi.Transaction()
				t.add {_type:"Picture", "product_id":prod.product_id}
				s.execute('get', t)
				.then (results)->
					console.log "Product Pics", results
					pics.resolve results.entities
				.catch (err)->
					console.log "error getting related", err

				pics.promise
			storage.getProductAttachments = (prod)->
				atts = $q.defer()

				t = new window.JEFRi.Transaction()
				t.add {_type:"Attachment", "product_id":prod.product_id}
				s.execute('get', t)
				.then (results)->
					console.log "Product Attachments", results
					atts.resolve results.entities
				.catch (err)->
					console.log "error getting related", err

				atts.promise
			storage.getProductsByCategory = (cat)->
				prods = $q.defer()

				if typeof cat == "string"
					cat_id = cat
				else
					cat_id = cat.category_id

				t = new window.JEFRi.Transaction()
				t.add {_type:"Product", "category_id":cat_id}
				t.add {_type:"Category"}
				t.add {_type:"Picture"}
				s.execute('get', t)
				.then (results)->
					cat_entity = runtime.find {_type: "Category", category_id: cat_id}
					cats = runtime.find {_type: "Category"}
					console.log "Category Products", results
					result = {
						category: cat_entity.pop() #Screw you runtime.find
						all_categories: cats
					}
					prods.resolve result
				.catch (err)->
					console.log "error getting related", err

				prods.promise
			storage.getProduct = (product_id)->
				prod = $q.defer()

				t = new window.JEFRi.Transaction()
				t.add {_type:"Product", "product_id":product_id, "pictures":{}}
				t.add {_type:"Category"}
				s.execute('get', t)
				.then (results)->
					prod_entity = runtime.find {_type: "Product", product_id: product_id}
					cats = runtime.find {_type: "Category"}
					console.log "Single Product and cats", results
					result = {
						all_categories: cats
						product: prod_entity.pop() #Screw you runtime.find
					}
					prod.resolve result
				.catch (err)->
					console.log "error getting related", err

				prod.promise

			storage.getAllProducts = ()->
				prods = $q.defer()

				t = new window.JEFRi.Transaction()
				t.add {_type:"Product"}
				t.add {_type:"Category"}
				t.add {_type:"Picture"}
				t.add {_type:"Attachment"}
				s.execute('get', t)
				.then (results)->
					cats = runtime.find {_type: "Category"}
					products = runtime.find {_type: "Product"}
					result = {
						categories: cats
						products: products
					}
					prods.resolve result
				.catch (err)->
					console.log "error getting related", err

				prods.promise

			storage.upload = (files, spec)->
				self = this
				uploading = $q.defer()
				uploader.upload("/upload", files[0], spec)
				.then (r)->
					console.log "File Upload Success", r
					trans = JSON.parse(r.response)
					param = {'picture_id' : trans.entities[0].picture_id}
					test = runtime.find({_type:"Picture", "picture_id":"8288a54b-360e-40bf-bd33-4ee0ef2e72de"})
					self.get("Picture", param)
					.then (results)->
						uploading.resolve(results.pop())
					.catch (err)->
						console.log "Failed to get the pic entity", err
				.catch (err)->
					console.log "File Upload FAIL!", err
					uploading.reject()
				uploading.promise

			loading.resolve({'products':products, 'categories':categories, 'attachments':attachments, 'pictures':pictures}) #Why doesn't resolving $q trigger a digest?
			$rootScope.$digest()

	.catch (e)->
		console.error "Couldn't load context!"
		console.error e.message, e
	storage
