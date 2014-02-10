db = require 'odbc'

cn = ""

module.exports = do ->
	connect: ()->
		db.open cn, (err)->
			if err
				console.log "ODBC Error: ", err
			else
				console.log "ODBC: ", db
