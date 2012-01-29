(function() {
  var PostieEvent, PostieSender;

  window.Postie = (function() {

    Postie.prototype.listenCallback = null;

    Postie.prototype.domain = '*';

    function Postie(options) {
      if (options == null) options = {};
      this;
    }

    Postie.prototype.send = function(frames, data, callback) {
      console.log(frames);
      return new PostieSender(frames, data, callback);
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
      this.sourceWindow = event.source;
      ({
        data: this.data,
        origin: origin,
        source: this.sourceWindow
      });
    }

    return PostieEvent;

  })();

  PostieSender = (function() {

    function PostieSender(frames, data, callback) {
      this.parseFrames(frames);
      this.prepareData;
      this.dispatch;
      callback();
    }

    PostieSender.prototype.parseFrames = function(frames) {};

    return PostieSender;

  })();

}).call(this);
