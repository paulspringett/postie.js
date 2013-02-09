# Use chai assertation library
expect = require('chai').expect
sinon = require('sinon')

# Require file(s) to test against
src = require './../lib/postie.js'
Postie = src.Postie

before ->
  Postie.Client::_listen = -> true
  Postie.Client::_createFrame = (serverUrl, callback) -> callback()

  @client = new Postie.Client('http://example.org/background.html')
  @client._frame =
    postMessage: (payload, allowedHosts) ->
      true

describe 'ready', ->
  it 'should call the ready callback', ->
    callback = sinon.spy()
    @client.ready(callback)
    expect(callback.called).to.equal(true)
