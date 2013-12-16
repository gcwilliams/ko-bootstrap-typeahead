module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON "package.json"
    
    clean: ["dist/"]

    coffee:
      options:
        bare: true
      dev:
        files:
          "dist/js/app.js": "src/coffee/app.coffee"
          "dist/js/constants.js": "src/coffee/constants.coffee"
          "dist/js/bindingHandler.js": "src/coffee/bindingHandler.coffee"
          "dist/js/arrayFilter.js": "src/coffee/arrayFilter.coffee"
          "dist/js/dummyService.js": "src/coffee/dummyService.coffee"

    copy:
      dev:
        files: [
          { expand: true, flatten: true, cwd: "src/", src: "js/**.js", dest: "dist/js" }
          { expand: true, flatten: true, cwd: "src/", src: "css/**.css", dest: "dist/css" }
          { expand: true, flatten: true, cwd: "src/", src: ["templates/**.html"], dest: "dist/templates" }
          { expand: true, flatten: true, cwd: "src/", src: ["host.html"], dest: "dist/" }
          { expand: true, flatten: true, cwd: "bower_components/", src: ["bootstrap/dist/css/bootstrap.css"], dest: "dist/css/" }
          { expand: true, flatten: true, cwd: "bower_components/", src: ["bootstrap/dist/css/bootstrap-theme.css"], dest: "dist/css/" }
          { expand: true, flatten: true, cwd: "bower_components/", src: ["requirejs/require.js"], dest: "dist/lib/" }
          { expand: true, flatten: true, cwd: "bower_components/", src: ["requirejs-text/text.js"], dest: "dist/lib/" }
          { expand: true, flatten: true, cwd: "bower_components/", src: "knockout.js/knockout.debug.js", dest: "dist/lib/" }
          { expand: true, flatten: true, cwd: "bower_components/", src: "jquery/jquery.js", dest: "dist/lib/" }
        ]

    watch:
      options:
        cwd: "src/"
      files: ["coffee/**", "js/**", "lib/**", "css/**", "templates/**", "host.html"]
      tasks: ["default"]

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-watch"

  grunt.registerTask "default", ["clean", "coffee:dev", "copy:dev"]