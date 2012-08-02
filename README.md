## Postie.js

Send and receive data between frames using the HTML5 postMessage API.

Postie.js make it really easy to send and return data between the client (in one window) and the server (in an embedded frame).


### Installation

Add the `postie.js` file to the HTML for both files.

```html
<script src="postie.js" />
```

### Usage

##### Step 1) Create a list of endpoints for the server

```javascript
// iframe
var myReceiver = {
  getUser: function(id) {
    var user = new User(id);
    user.fetch(success: function() {
      return user;
    });
  },
  getFoo: function() {
    return 'foo';
  }
};
```

##### Step 2) Create the server and start listening

```javascript
// iframe
var server = new Postie.Server(receiver: myReceiver)
server.listen()
```

##### Step 3) Create the client

```javascript
// main window
var client = new Postie.Client( $('iframe')[0] );
client.ready(function() {
  // start calling endpoints here
});
```

##### Step 4) Call an endpoint and receive the response

```javascript
// main window
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
