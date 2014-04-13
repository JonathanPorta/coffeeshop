path = require 'path'
http = require 'http'
csv = require 'csv'
fs = require 'fs'
JEFRi = require "jefri"
uploader = require './uploader'

importer = do ->
	post: (incoming)->
		console.log "Incoming import."
	full: (file, runtime, store, root)->
			#get all cats
			getCatsTrans = new JEFRi.Transaction()
			getCatsTrans.add {"_type":"Category"}
			categories = {}
			store['get'](getCatsTrans)
			.then (gotten)->
				for cat in gotten.entities
					categories[cat.name] = cat

			importer.csv file, (row, index)->
#				row[0] #main-cat
#				row[1] #sub-cat
#				row[2] #name
#				row[3] #prod no
#				row[4] #price
#				row[5] #img-url
#				row[6] #size -optional
#				row[7] #description

				#get all cats
				getProdTrans = new JEFRi.Transaction()
				getProdTrans.add {"_type":"Product", "partno":row[3]}
				store['get'](getProdTrans)
				.then (gotten)->
					console.log gotten
					if(gotten.entities.length == 0)
						#check main cat
						if(categories.hasOwnProperty(row[0]))
							mainCategory = categories[row[0]]
						else
							mainCategory = runtime.build "Category", {"name":row[0]}
							categories[row[0]] = mainCategory

						#check subcat
						if(categories.hasOwnProperty(row[1]))
							subCategory = categories[row[1]]
						else
							subCategory = runtime.build "Category", {"name":row[1]}
							subCategory.parent = mainCategory
							categories[row[1]] = subCategory

						#build entity
						#save picture
						newPicEntity = runtime.build "Picture", {}

						temppath = path.join root,".tmp","temp" + new Date().getTime() + index
						importer.download row[5], temppath, (downloadedpath)->
							uploader.save path.join(root, ".uploads"), {'path':downloadedpath}, newPicEntity, (entity)->
								console.log "FILE WAS UPLOADED WITH SUCCESS AND MUCH FANFARE!"

								product = runtime.build "Product", {"name":row[2], "partno":row[3], "description":row[7]}
								product.category = subCategory
								newPicEntity.product = product

								pictrans = new JEFRi.Transaction()
								pictrans.add entity
								pictrans.add mainCategory
								pictrans.add subCategory
								pictrans.add product

								store['persist'](pictrans)
								.then (saved)->
									console.log "Entity Saved!"
					else
						console.log "Product already in DB: " + row[3]

	download: (url, targetpath, cb)->
		targetfile = fs.createWriteStream targetpath
		http.get(url, (response)->
			response.pipe(targetfile)
			targetfile.on 'finish', ()->
				targetfile.close()
				console.log "Downloaded: " + targetpath
				cb(targetpath)
		)
	csv: (file, cb)->
		csv()
		.from.stream(fs.createReadStream(file))
		.to.path(file+'.out')
		.transform((row)->
			#Can manipulate rows here.
			row
		).on('record', (row, index)->
			console.log "Read row: " + index
			cb(row, index)
		).on('end', (count)->
			console.log('Number of lines: '+count)
		).on('error', (error)->
			console.log(error.message)
		)

module.exports = importer
