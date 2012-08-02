## Postie.js

Postie makes it easy send data back and forth between a web page and an embedded iframe.

Under the hood it uses the HTML5 postMessage API.

### Why was it created?

We needed to create a bookmarklet that could communicate to a server from any domain. Cross-domain policy issues made this really difficult.
To get round this we embedded an iframe with a page on the correct domain and used Postie.js to talk between the web page and the iframe.

We've worked really hard to abstract away the native postMessage API and provide some really powerful features.

* HTML5 postMessage doesn't support sending complex data structures; it can only send Strings. Postie.js allows you to send any valid JSON, including simple Strings or Integers.
* Whereas HTML5 postMessage only does one-way sending, Postie.js allow you to send data and receive the response in a callback function, providing a neat request/response communication format.

### How does it work?

Postie.js comes in two parts, the Client and the Server.

1. The Client allows sending of data to the server (in another window) and handles the response, passing it to your provided callback function.
2. The Server listens for requests from the Client, passes the request to a object "Receiver" and sends back the result.
3. The Receiver object is simply a JSON object of key-value pairs where the key is the endpoint for the client to call and the value is a function that takes any data send by the client and provides a response.

### Installation

Add the `postie.js` file to the HTML for both files.

```html
<script src="postie.js"></script>
```

### Usage

##### Step 1) Create a list of endpoints for the server

This should be defined in your background page / iframe

```javascript
var myReceiver = {
  
  // First endpoint gets a User by an ID and returns a JSON representation of it.
  getUser: function(id) {
    var user = new User(id);
    user.fetch(success: function() {
      return user.toJSON();
    });
  },
  
  // Second endpoint simply returns the string of 'foo' 
  getFoo: function() {
    return 'foo';
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

This should be defined in your main window

```javascript
var client = new Postie.Client( $('iframe')[0] );
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
