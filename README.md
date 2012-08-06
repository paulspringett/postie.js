## Postie.js

Postie makes it easy send data back and forth between a web page and an embedded iframe.

Under the hood it uses the HTML5 postMessage API.

### Why was it created?

We needed to create a bookmarklet that could communicate with our server from a script on any domain. Cross-domain policy issues made this really difficult.
To get round this we embedded an iframe with a page on the correct domain and used Postie.js to talk between the web page and the iframe.

We've worked really hard to abstract away the native postMessage API and provide some really powerful features.

* HTML5 postMessage doesn't support sending complex data structures; it can only send Strings. Postie.js allows you to send any valid JSON, including simple Strings or Integers.
* Whereas HTML5 postMessage only does one-way sending, Postie.js allow you to send data and receive the response in a callback function, providing a neat request/response communication format.

### How does it work?

Postie.js comes in two parts, the Client and the Server. Oh, and a "Receiver" object. Wait, that's three parts!

1. The Client enables sending of data to the Server (in another window) and handles the response sent back, passing it to your provided callback function.
2. The Server listens for requests from the Client, passes the request to a object "Receiver" and sends back the result.
3. The Receiver object is simply a JSON object of key-value pairs where the key is the name of the endpoint for the client to call and the value is a function that takes any data send by the client and provides whatever response you need.

### Installation

Add the `postie.js` file to the HTML for both files.

```html
<script src="postie.js"></script>
```

### Usage

Enough talk, time for an example:

##### Step 1) Create a list of endpoints for the server

This should be defined in your background page / iframe

```javascript
var myReceiver = {

  // First endpoint gets a User by an ID and returns a JSON representation of it.
  // We're doing this with some Backbone here.
  // id - This is the user id sent from the client
  // sendResponse - this is a function provided by the server. Call it, passing any
  // data you want. This is send the response back to the client
  getUser: function(id, sendResponse) {
    var user = new User(id);
    user.fetch(success: function() {
      sendResponse(user.toJSON());
    });
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
create an iframe inside the DOM. Run all your calls to the Server inside the `ready` callback to ensure the Server is ready.

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
  // => Got user: User

  client.getFoo(function(data) {
    console.log('Got foo:', data);
  });
  // => Got foo: 'foo'

});
```
