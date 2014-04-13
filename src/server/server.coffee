path = require "path"
root = path.join __dirname, "..", ".."

nconf = require "nconf"
nconf.argv()
	.env()
	.file
		file: path.join root, 'server.json'
	.defaults
		port: 3000

JEFRi = require "jefri"
Stores = require "jefri-stores"

importer = require './importer'
connector = require './connector'
uploader = require './uploader'

runtime = new JEFRi.Runtime ""
store = new Stores.Stores.FileStore runtime: runtime

ya = require 'ya-csv'

importedUrls = {}

express = require "express"
app =
	express()
		.use(express.json({limit: '50mb'}))

		.use(express.bodyParser())

		.get '/context.json', (req, res)->
			res.set "content-type", "application/json"
			res.sendfile path.join root, "build", "context.json"

		.post /\/(get|persist)/, (req, res)->
#			console.log 'get/persist', req, res
			method = req.params[0]
			transaction = new JEFRi.Transaction()
			transaction.add req.body.entities
			store[method](transaction)
			.then (gotten)->
				res.jsonp gotten

		.post '/upload', (req, res)->
			console.log 'Post to /upload! It better be a file!'
			newPicEntity = runtime.build "Picture", JSON.parse req.body.spec
			uploader.save(path.join(root, ".uploads"), req.files.file, newPicEntity, (entity)->
				console.log "FILE WAS UPLOADED WITH SUCCESS AND MUCH FANFARE!"
				pictrans = new JEFRi.Transaction()
				pictrans.add entity
				store['persist'](pictrans)
				.then (saved)->
					console.log "Uploaded picture entity was saved."
					res.jsonp saved
			)

		.get '/bower/:module/:file', (req, res) ->
			res.set "content-type", "text/javascript"
			res.sendfile path.join root, "bower_components", req.params.module, req.params.file

		.get '/bower/bootstrap.js', (req, res) ->
			res.set "content-type", "text/javascript"
			res.sendfile path.join root, "bower_components", "bootstrap", "dist", "js", "bootstrap.js"

		.get /^\/vendor/, (req, res)->
			res.sendfile path.join root, req.path

		.get '/page.css', (req, res)->
			res.set "content-type", "text/css"
			res.sendfile path.join root, "build", "page.css"

		.get '/fonts/:font', (req, res)->
			res.sendfile path.join root, "bower_components", "bootstrap", "fonts", req.params.font

		.get '/bundle.js', (req, res) ->
			res.set "content-type", "text/javascript"
			res.sendfile path.join root, "build", "bundle.js"

		.get '/templates.js', (req, res) ->
			res.set "content-type", "text/javascript"
			res.sendfile path.join root, "build", "templates.js"

		.get '/test.json', (req, res) ->
			res.set "content-type", "text/javascript"
			res.sendfile path.join root, "build", "test.json"

		.post '/chrome', (req, res) ->
#		var payload = {
#			"url" : urls,
#			"cat" : cat,
#			"subCat":subCat
#		};

			result = 
				"url": ""
				"count": 0
				"msg": ""

			writer = ya.createCsvFileWriter path.join(root, 'scrape.csv'), {'flags': 'a'}

			for key,val of req.body.url
				result.url = key
				if(importedUrls.hasOwnProperty result.url)
					result.msg = "URL has already been scraped. " + importedUrls[result.url] + " product(s) are in the DB."
				else
					result.count = val.length
					for id in val
						#write to flattened CSV file for AWS.
						writer.writeRecord [key,req.body.cat, req.body.subCat, id]
					result.msg = "No products added from " + result.url + "!"
					if(result.count > 0)
						result.msg = result.count + " products added from " + result.url + " to "+req.body.cat+"->"+req.body.subCat+"!"
						importedUrls[result.url] = result.count

			console.log result
			res.jsonp result

		.post '/import', (req, res) ->
			importer.import req
			res.end "Elo."

		.get '/import', (req, res) ->
			importer.full "/home/portaj/Downloads/import2.csv", runtime, store, root
			res.end "importing... /home/portaj/Downloads/import.csv"

		.get '/uploads/:size/:file', (req, res) ->
			res.set "content-type", "image/jpeg"
			res.sendfile path.join root, ".uploads", req.params.size, req.params.file

		.get '/placeholder/:size', (req, res) ->
			res.set "content-type", "image/jpeg"
			res.sendfile path.join root, "vendor", "placeholder", req.params.size+".jpg"

		.get '/', (req, res) ->
			res.sendfile path.join root, "build", "index.html"

module.exports = do ->
	serve: ->
		port = nconf.get('port')
		server = app.listen port
		console.log "coffeeshop App Server listening on port #{port}"
		setTimeout (-> runtime.load "http://localhost:#{port}/context.json"), 1000
		runtime.ready.then(-> console.log "context be loaded, son.")
		.catch((e)->
			console.error e.message, e
		)
	stop: ->
		server?.close()
