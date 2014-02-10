should = require "should"
server = require "../server"
request = require "request"

get = (path, d, cb) ->
	request path, (e, r, b) ->
		cb e, r, b
		d()

index = (d, cb) -> get "http://localhost:3000/", d, cb
bundle = (d, cb) -> get "http://localhost:3000/bundle.js", d, cb
styles = (d, cb)-> get "http://localhost:3000/page.css", d, cb

Callbacks =
	OK: (e, res) ->
		res.statusCode.should.equal 200

describe "Server", ->

	before ->
		server.serve()

	describe "/", ->
		it "binds on a known port", (done) ->
			index done, (err, response) ->
				should.not.exist err, "Error when GETting (#{err})"

		it "returns 200 when requesting /", (done) ->
			index done, (e, res) ->
				res.statusCode.should.equal 200

		it "returns an index at /", (done) ->
			index done, (e, r, body) ->
				body.should.match /^<!DOCTYPE html><html>/
				body.should.match /<\/html>\s*$/

	describe "index.html", ->
		it "returns a page with a title", (done) ->
			index done, (e, r, body) ->
				body.should.match ///
					<title>[^<]*coffeeshop[^<]*</title>
				///,
				"page needs a title"

		it "returns a page with ng:app", (done) ->
			index done, (e, r, body) ->
				body.should.match ///
					ng:app="coffeeshop"
				///,
				"AngularJS app is not defined on main page."

		it "returns an ng-view", (done) ->
			index done, (e, r, body) ->
				body.should.match ///
					ng-view
				///,
				"No ng:view is defind on page."

		it "sets a viewport", (done)->
			index done, (e, r, body)->
				body.should.match /<meta[^>]+name="viewport"/

	describe "bundle.js", (done) ->
		it "returns a bundle", (done) ->
			bundle done, Callbacks.OK

		it "returns a js bundle", (done) ->
			bundle done, (e, res) ->
				res.headers["content-type"].should.equal "text/javascript"

		#it "defines an Angular module", (done) ->
			#bundle done, (e, r, body) ->
				#body.contains "angular.module(\"todo\""

	describe "page.css", ->
		it "returns a stylesheet", (done)->
			styles done, Callbacks.OK

		it "returns a css bundle", (done)->
			styles done, (e, res)->
				res.headers["content-type"].should.equal "text/css"

	describe "bower", ->
		it "serves Bower resources", (done) ->
			request "http://localhost:3000/bower/angular/angular.js", (e, res) ->
				res.statusCode.should.equal 200
				done()

	describe "fonts", ->
		it "serves fonts from bootstrap", (done)->
			request "http://localhost:3000/fonts/glyphicons-halflings-regular.woff", (e, res)->
				res.statusCode.should.equal 200
				done()
