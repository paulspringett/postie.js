## Postie.js

Postie makes it easy send rich (JSON) data back and forth between a web page and an embedded iframe.

Under the hood it uses the [HTML5 postMessage API](https://developer.mozilla.org/en/docs/DOM/window.postMessage).

### About Postie.js

Postie.js abstracts away the native postMessage API for a number of reasons:

* HTML5 postMessage doesn't support sending complex data structures; it can only send Strings. Postie.js allows you to send any valid JSON, including simple Strings or Integers.
* Postie.js allows you to send data and receive the response in a callback function, providing a much more convenient request/response communication format.

### When would I use it?

It's ideal for creating bookmarklets and scripts that are injected into 3rd party sites and need to communicate with your app.

### How does it work?

Postie.js comes in two parts, the Client and the Server. The Server instance is also passed a JSON object (called the Receiver) that defines the available endpoints.

1. The Client enables sending of data to the Server (in another frame) and handles the response sent back.
2. The Server listens for requests from the Client, passes the request to a "Receiver" object and sends back the result to the client.
3. The Receiver object is simply a JSON object of key-value pairs where the key is the name of the endpoint for the client to call, and the value is a function that takes any data send by the client and provides whatever response you need.

### Installation

Add the `postie.js` file to the pages you neec the client and server on.

```html
<script src="postie.js"></script>
```

### Usage

Enough talk, time for an example:

##### Step 1) Create a list of endpoints for the server

This should be defined in your background page (2).

```javascript
var myReceiver = {

  // First endpoint gets a User by an ID and returns a JSON representation of it.
  // id - This is the user id sent from the client
  // sendResponse - this is a function provided by the Postie.js server. Call it, passing any
  // data you want. This is send the response back to the client
  getUser: function(id, sendResponse) {

    $.get('/users/' + id + '.json',
      success: function(data, status, xhr) {
        sendResponse(data);
      }
    );

  },

  // Second endpoint simply returns the string of 'foo'.
  getFoo: function(sendResponse) {
    sendResponse('foo');
  }
};
```

##### Step 2) Create the server and start listening

This should be defined in your background page / iframe

```javascript
var server = new Postie.Server(receiver: myReceiver)
server.listen()
```

##### Step 3) Create the client

This should be defined in your main window. Pass the URL of where the Server instance is listening. The Client will
create an iframe inside the DOM. Run all your calls to the Server inside the `ready` callback to ensure the iframe has loaded.

```javascript
var client = new Postie.Client('http://localhost:8081/bookmarklet/background.html');
client.ready(function() {
  // start calling endpoints here
});
```

##### Step 4) Call an endpoint and receive the response

This should be defined in your main window

```javascript
client.ready(function() {
  console.log( client._endpoints );
  // => ['getUser', 'getFoo']

  client.getUser(123, function(user) {
    console.log('Got user:', user);
  });
  // => Got user: { id: 123, name: 'J Bloggs', favColor: 'green' }

  client.getFoo(function(data) {
    console.log('Got foo:', data);
  });
  // => Got foo: 'foo'

});
```
