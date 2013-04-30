{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', (options = {}) ->
  build()

task 'watch', 'watch for changes and rebuild postie', () ->
  watch()

task 'spec', 'Build the latest changes & run the specs using Mocha', () ->
  build()
  spec()

# Build Coffee files into single JS file
build = (options = {}) ->
  exec "rm lib/postie.js lib/postie.min.js"

  console.log "Compiling src/ into lib/postie.js"
  run "coffee --compile --join lib/postie.js src/", ->
    minify()

watch = () ->
  exec "rm lib/postie.js"

  console.log "Watching src/ and compiling into lib/postie.js"
  run "coffee --watch --compile --join lib/postie.js src/"

# Run the specs with Mocha
spec = (options = {}) ->
  reporter = options.reporter or 'spec'
  run "mocha --colors --reporter #{reporter} --compilers coffee:coffee-script spec/*.coffee"

# Minify the compiled JS
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
