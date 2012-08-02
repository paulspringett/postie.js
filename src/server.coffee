class Postie.Server
  endpoints: []

  constructor: (options = {}) ->
    @receiver = options.receiver
    @listen()

    console.log("@receiver", @receiver)

  receive: (rawEvent) =>
    event = new Postie.Event(rawEvent)

    if event.method is '_getEndpoints'
      console.log '_getEndpoints'
      @endpoints = @listEndpoints(@receiver)
      @dispatch(event, @endpoints)
    else
      responseData = @receiver[event.method](event.data)

    @dispatch(event, responseData)

  dispatch: (event, responseData) ->
    frame = event.source

    payload = @payload(event.uuid, responseData)
    frame.postMessage payload, '*'
    event.uuid

  payload: (uuid, data) ->
    try
      message = { uuid: uuid, payload: data }
      JSON.stringify(message)
    catch err
      console.log "Could not stringify data: #{data} with #{err}"

  listen: ->
    if window.addEventListener?
      window.addEventListener 'message', @receive, false
    else if window.attachEvent?
      window.attachEvent 'onmessage', @receive
    else
      throw new Error 'cannot bind to postMessage "message" event on window'

  listEndpoints: (receiver) ->
    for method, fn of receiver
      @endpoints.push method

    console.log "listEndpoints", @endpoints
    @endpoints
