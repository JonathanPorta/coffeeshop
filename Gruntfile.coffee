module.exports = (grunt) ->
	require('./recurse')(grunt)

	[
		'./src/client'
		'./src/server'
		'./src/features'
	].map grunt.grunt

	grunt.NpmTasks = ['grunt-contrib-watch', 'grunt-contrib-copy']

	grunt.Config =
		copy:
			context:
				files:
					'build/context.json':'src/context.json'

		watch:
			base:
				files:[
					'src/client/**/**/*jade'
					'src/client/**/**/*coffee'
					'src/client/**/**/*less'
					'src/server/**/*coffee'
					'src/context.json'
				]
				tasks: ['base']
			all:
				files:[
					'src/features/**/*coffee'
					'src/features/**/*feature'
					'src/server/**/*coffee'
					'src/client/**/**/*jade'
					'src/client/**/**/*coffee'
					'src/client/**/**/*less'
				]
				tasks:['default']

	#console.log grunt.Config
	#console.log grunt.NpmTasks
	grunt.initConfig grunt.Config
	grunt.loadNpmTasks npmTask for npmTask in grunt.NpmTasks

	grunt.registerTask 'test', [
		'lint'
#		'mochaTest:server'
#		'karma:unit'
#		'features'
	]

	grunt.registerTask 'base', [
		'jsonlint:context'
		'copy:context'
		'build'
#		'mochaTest:server'
#		'karma:unit'
	]

	grunt.registerTask 'compress', [
		'uglify:all'
		'cssmin:all'
	]

	grunt.registerTask 'default', [
		'build'
		'test'
		'compress'
	]
