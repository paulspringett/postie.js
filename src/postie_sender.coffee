class PostieSender
  allowedDomains: ['*']
  uuid: null

  constructor: (@frame, @data, options = {}) ->
    @parseFrame()
    @dispatch()
    options.callback() if options.callback

  parseFrame: ->
    if typeof(@frame) is 'string'
      return @frame = document.getElementById(@frame)
    
    if typeof(@frame.contentWindow) is 'object'
      @frame = @frame.contentWindow

    try
      if typeof(@frame.postMessage) is 'function'
        return @frame
    catch err
      console.log "Could not send to frame: #{@frame}, must be an iframe"

  payload: ->
    try
      message = { uuid: @generateUuid(), payload: @data }
      JSON.stringify(message)
    catch err
      console.log "Could not stringify data: #{@data} with #{err}"

  dispatch: ->
    console.log @frame.name
    console.log @payload()
    console.log @domains()
    
    @frame.postMessage(@payload(), @domains())

  domains: (options = {}) ->
    domains = options.domains or @allowedDomains # @frame.src
    domains.join(', ')
  
  generateUuid: ->
    return @uuid if @uuid

    s4 = ->
      (((1+Math.random())*0x10000)|0).toString(16).substring(1)
    @uuid = "#{s4()}#{s4()}-#{s4()}-#{s4()}-#{s4()}-#{s4()}#{s4()}#{s4()}"

