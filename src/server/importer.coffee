http = require 'http'

module.exports = do ->
	import: (url)->
		console.log "Importing from a URL: " + url
		http.get url, (res)->
			res.on "data", (data)->
				console.log "Got a Response!"
				console.log res.statusCode
#				products = JSON.parse data
#				console.log "Products: " + products.length
				console.log data
		.on 'error', (e)->
			console.log "Error!"
			console.log(e)
