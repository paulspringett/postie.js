{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', (options = {}) ->
  build()

task 'watch', 'watch for changes and rebuild postie', () ->
  build(watch: true)

task 'spec', 'Build the latest changes & run the specs using Mocha', () ->
  build()
  spec()

build = (options = {}) ->
  compileFlag = options.compileFlag or '--compile'
  compileFlag = '--watch' if options.watch

  exec "rm lib/postie.js"

  console.log "Compiling src/ into lib/postie.js"
  run "coffee #{compileFlag} --join lib/postie.js src/", ->
    minify()

spec = (options = {}) ->
  reporter = options.reporter or 'spec'
  run "mocha --colors --reporter #{reporter} --compilers coffee:coffee-script spec/*.coffee"

minify = () ->
  run "uglifyjs --output lib/postie.min.js lib/postie.js", ->
    console.log "Minified lib/postie.js to lib/postie.min.js"

run = (command, success) ->
  exec "#{command}", (err, stdout, stderr) ->
    console.log stdout if stdout

    if err
      throw err
      console.log stderr
    else
      success?()
