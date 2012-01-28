(function() {
  var Postie, PostieEvent;

  Postie = (function() {

    Postie.prototype.listenCallback = null;

    function Postie(options) {
      if (options == null) options = {};
    }

    Postie.prototype.send = function(frames, data, callback) {
      return console.log(frames);
    };

    Postie.prototype.listen = function(callback) {
      this.listenCallback = callback;
      return this.bindEventListener;
    };

    Postie.prototype.onMessage = function(event) {
      event = this.parseEvent(event);
      console.log(event);
      return this.listenCallback(event);
    };

    Postie.prototype.parseEvent = function(rawEvent) {
      return new PostieEvent(rawEvent);
    };

    Postie.prototype.bindEventListener = function() {
      if (typeof window.addEventListener === !'undefined') {
        return window.addEventListener('message', this.onMessage, false);
      } else if (typeof window.attachEvent === !'undefined') {
        return window.attachEvent('onmessage', this.onMessage);
      }
    };

    return Postie;

  })();

  PostieEvent = (function() {

    function PostieEvent(event) {
      if (event == null) event = {};
      this.origin = event.origin;
      this.data = JSON.parse(event.data);
      ({
        data: this.data,
        origin: origin
      });
    }

    return PostieEvent;

  })();

}).call(this);
