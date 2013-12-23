angular.module('coffeeshop').service "uploader", ($q, $rootScope)->
	uploader =
		upload: (url, file, spec = {})->
			uploading = $q.defer()
			data = new FormData()
			xhr = new XMLHttpRequest()

			spec = JSON.stringify spec

			data.append 'file', file
			data.append 'spec', spec

			xhr.onreadystatechange = (r)->
				if @readyState is 4
					if xhr.status is 200
						$rootScope.$apply ->
							uploading.resolve xhr
					else
						$rootScope.$apply ->
							uploading.reject xhr
			xhr.open "POST", url, true
			xhr.send data
			return uploading.promise
	uploader
