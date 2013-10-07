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

runtime = new JEFRi.Runtime ""
store = new JEFRi.Stores.FileStore runtime: runtime

express = require "express"
app =
	express()
		.use(express.bodyParser())

		.get '/context.json', (req, res)->
			res.set "content-type", "application/json"
			res.sendfile path.join root, "build", "context.json"

		.post /\/(get|persist)/, (req, res)->
			console.log 'get/persist', req, res
			method = req.params[0]
			transaction = new JEFRi.Transaction()
			transaction.add req.body.entities, true
			store[method](transaction)
			.then (gotten)->
				res.jsonp gotten

		.get '/bower/:module/:file', (req, res) ->
			res.set "content-type", "text/javascript"
			res.sendfile path.join root, "bower_components", req.params.module, req.params.file

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
