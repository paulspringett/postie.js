{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', (options = {}) ->
  build()

task 'watch', 'watch for changes and rebuild postie', () ->
  build(watch: true)

build = (options = {}) ->
  output = options.output or 'lib/'
  source = options.source or 'src/'
  flags = options.flags or '--compile --output'
  flags = '--compile --watch' if options.watch

  exec "coffee #{flags} #{output} #{source}", (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
