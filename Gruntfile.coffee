module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    
    clean:
      default:
        ["dist/"]
      release:
        ["dist/js/*.js", "!dist/js/bootstrap-typeahead.js", "dist/css/*.css", "!dist/css/bootstrap-typeahead.css", "dist/templates/**", "dist/lib/**"]

    coffee:
      options:
        bare: true
      dev:
        files:
          "dist/js/app.js": "src/coffee/app.coffee"
          "dist/js/constants.js": "src/coffee/constants.coffee"
          "dist/js/bindingHandler.js": "src/coffee/bindingHandler.coffee"
          "dist/js/dummyService.js": "src/coffee/dummyService.coffee"
      release:
        files:
          "dist/js/constants.js": "src/coffee/constants.coffee"
          "dist/js/bindingHandler.js": "src/coffee/bindingHandler.coffee"

    copy:
      dev:
        files: [
          { expand: true, flatten: true, cwd: "src/", src: "host.html", dest: "dist/" }
        ]
      common:
        files: [
          { expand: true, flatten: true, cwd: "src/", src: "js/**.js", dest: "dist/js" }
          { expand: true, flatten: true, cwd: "src/", src: "css/**.css", dest: "dist/css" }
          { expand: true, flatten: true, cwd: "src/", src: "templates/**.html", dest: "dist/templates" }
          { expand: true, flatten: true, cwd: "src/", src: "css/bootstrap.css", dest: "dist/css/" }
          { expand: true, flatten: true, cwd: "src/", src: "css/bootstrap-theme.css", dest: "dist/css/" }
          { expand: true, flatten: true, cwd: "src/", src: "lib/require.js", dest: "dist/lib/" }
          { expand: true, flatten: true, cwd: "src/", src: "lib/text.js", dest: "dist/lib/" }
          { expand: true, flatten: true, cwd: "src/", src: "lib/knockout.debug.js", dest: "dist/lib/" }
          { expand: true, flatten: true, cwd: "src/", src: "lib/jquery.js", dest: "dist/lib/" }
        ]

    requirejs:
      release:
        options:
          baseUrl: "dist/js/"
          name: "bindingHandler"
          optimize: "uglify"
          out: "dist/js/bootstrap-typeahead.js"
          stubModules: ["../lib/text"]

    watch:
      options:
        cwd: "src/"
      files: ["coffee/**", "js/**", "lib/**", "css/**", "templates/**", "host.html"]
      tasks: ["default"]

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-requirejs"

  grunt.registerTask "dev", ["clean:default", "coffee:dev", "copy:dev", "copy:common"]
  grunt.registerTask "default", ["clean:default", "coffee:release", "copy:common", "requirejs:release", "clean:release"]