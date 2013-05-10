describe 'ready', ->
  it 'should create an iframe', ->
    @client = new Postie.Client('http://example.org/background.html')
    @client.ready()
    expect(@client._frame).not.toBeNull()
