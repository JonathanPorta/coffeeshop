http = require 'http'
fs = require 'fs'
Q = require 'q'
path = require "path"
# im = require "imagemagick-native"
gm = require "gm"

module.exports = do ->
	save: (targetDirectory, file, entity, cb)->
		#Define Directories
		#TODO: Do this in a config file.
		ext = ".jpg"
		sizes = {
			full:
				path: path.join targetDirectory, "fullsize", entity.picture_id + ext
				url : "uploads/fullsize/" + entity.picture_id + ext
				width: null
				height: null
			large:
				path: path.join targetDirectory, "large", entity.picture_id + ext
				url : "uploads/large/" + entity.picture_id + ext
				width: 480
				height:480
			medium:
				path: path.join targetDirectory, "medium", entity.picture_id + ext
				url : "uploads/medium/" + entity.picture_id + ext
				width: 180
				height:180
			thumbnail:
				path: path.join targetDirectory, "thumb", entity.picture_id + ext
				url : "uploads/thumb/" + entity.picture_id + ext
				width: 80
				height:80
		}

		console.log "going to save uploaded file(s)", file.path

		# original = fs.readFileSync file.path
		# console.log "First read, now to resize:", entity

		# for size,specs of sizes
		# 	console.log "Resizing: " + size
		# 	resized = im.convert({
		# 		srcData: original
		# 		width: specs.width
		# 		height: specs.height
		# 		resizeStyle: "aspectfill"
		# 		quality: 75
		# 		format: 'JPEG'
		# 	})
		# 	entity[size] = specs['url']
		# 	fs.writeFileSync specs.path, resized, 'binary'

		cb(entity)



#promisor = ->
#    defer = Q.defer()
#    asyncFunction ->
#        if condition is good
#            defer.resolve()
#        else
#            defer.reject()
#    defer.promise

#promisee = ->
#    success = ->
#        console.log 'It worked!'
#    failure = ->
#        console.error 'It failed :('
#    promisor()
#    .then(success, failure)


# gm "convert" "label:Offline" "PNG:-"

# $ convert rose.jpg -resize 50% rose.png
