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

  exec "coffee #{compileFlag} --join #{output} #{source}", (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
