module.exports = (grunt) ->
	grunt.initConfig
		pkg: grunt.file.readJSON './src/package.json'
		
		dirs: ## setting up the directories. this is here for templating
			public: './_public/'
			release: './_release/'
		
		nodewebkit:
			options:
				version		: '0.9.2'
				build_dir	: '<%= dirs.release %>'
				mac			: true
				win			: false
				linux32		: false
				linux64		: false
			src: '<%= dirs.public %>**/*'


	# Load npm tasks
	grunt.loadNpmTasks 'grunt-node-webkit-builder'
	
	# grunt.registerTask 'default', ['watch']
	grunt.registerTask 'default', ['nodewebkit']