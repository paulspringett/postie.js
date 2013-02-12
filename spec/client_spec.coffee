# Use chai assertation library
expect = chai.expect

before ->
  @client = new Postie.Client('http://example.org/background.html')

describe 'ready', ->
  it 'should create an iframe', ->
    @client.ready()
    expect(@client._frame).to.be.an.instanceof(Window)
