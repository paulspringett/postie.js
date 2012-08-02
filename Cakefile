{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', (options = {}) ->
  build()

task 'watch', 'watch for changes and rebuild postie', () ->
  build(watch: true)

build = (options = {}) ->
  output = options.output or 'lib/postie.js'
  source = options.source or 'src/'
  compileFlag = options.compileFlag or '--compile'
  compileFlag = '--watch' if options.watch

  exec "rm #{output}"

  console.log "Compiling #{source} into #{output}"
  exec "coffee #{compileFlag} --join #{output} #{source}", (err, stdout, stderr) ->
    if err
      throw err
      console.log stderr

    console.log stdout if stdout
    # minify()

minify = () ->
  exec "uglifyjs --output lib/postie.min.js lib/postie.js", (err, stdout, stderr) ->
    if err
      throw err
      console.log stderr

    console.log stdout if stdout
    console.log "Minified lib/postie.js to lib/postie.min.js"