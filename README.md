## Postie.js

JavaScript wrapper for the HTML5 postMessage API, written in CoffeeScript

### Installation

    <script src="js/postie.js" />

### Usage

    var postie = new Postie();

    postie.listen(function(event) {
      
    });

    postie.send(frames[1], { foo: 'bar' }, function(response, request) {
      response.status # success or error
    });


### Development

You'll need Node.js, NPM & CoffeeScript

Install Node.js

    brew install node

Install NPM

    curl http://npmjs.org/install.sh | sh

Install CoffeeScript

    npm install -g coffee-script

 