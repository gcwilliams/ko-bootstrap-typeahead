module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    
    clean:
      default:
        ["dist/"]

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
      build:
        files: [
          { expand: true, flatten: true, cwd: "src/", src: "frag/**.js", dest: "dist/frag/" }
        ]
      release:
        files: [
          { expand: true, cwd: "dist/", src: "js/ko-bootstrap-typeahead.js", dest: "release" }
          { expand: true, cwd: "dist/", src: "css/ko-bootstrap-typeahead.css", dest: "release" }
          { expand: true, flatten: true, cwd: "dist/", src: "js/ko-bootstrap-typeahead.js", dest: "example/lib" }
          { expand: true, cwd: "dist/", src: "css/ko-bootstrap-typeahead.css", dest: "example" }
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
          { expand: true, flatten: true, cwd: "src/", src: "lib/almond.js", dest: "dist/lib/" }
        ]

    requirejs:
      build:
        options:
          baseUrl: "dist/js/"
          name: "../lib/almond"
          include: ["bindingHandler"]
          optimize: "uglify"
          out: "dist/js/ko-bootstrap-typeahead.js"
          stubModules: ["../lib/text"]
          wrap:
            startFile: "dist/frag/start.js"
            endFile: "dist/frag/end.js"

    watch:
      options:
        cwd: "src/"
      files: ["coffee/**", "js/**", "lib/**", "css/**", "templates/**", "host.html"]
      tasks: ["dev"]

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-requirejs"

  grunt.registerTask "dev", ["clean", "coffee:dev", "copy:dev", "copy:common"]
  grunt.registerTask "default", ["clean", "coffee:release", "copy:common", "copy:build", "requirejs:build", "copy:release", "clean"]