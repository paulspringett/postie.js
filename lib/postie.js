(function() {
  var Postie, PostieEvent, PostieSender,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Postie = (function() {

    Postie.prototype.listenCallback = null;

    Postie.prototype.domain = '*';

    function Postie(options) {
      if (options == null) options = {};
      this.onMessage = __bind(this.onMessage, this);
      console.log("constructor...");
      this;
    }

    Postie.prototype.send = function(frames, data, callback) {
      var sender;
      return sender = new PostieSender(frames, data, callback);
    };

    Postie.prototype.listen = function(callback) {
      this.listenCallback = callback;
      return this.bindEventListener();
    };

    Postie.prototype.onMessage = function(rawEvent) {
      var event;
      event = this.parseEvent(rawEvent);
      console.log("onMessage");
      console.log(event);
      return this.listenCallback(event);
    };

    Postie.prototype.parseEvent = function(rawEvent) {
      return new PostieEvent(rawEvent);
    };

    Postie.prototype.bindEventListener = function() {
      if (typeof window.addEventListener !== 'undefined') {
        return window.addEventListener('message', this.onMessage, false);
      } else if (typeof window.attachEvent !== 'undefined') {
        return window.attachEvent('onmessage', this.onMessage);
      }
    };

    return Postie;

  })();

  window || (window = {});

  window.Postie = Postie;

  PostieEvent = (function() {

    PostieEvent.prototype.success = false;

    function PostieEvent(event) {
      var message;
      if (!event) {
        throw "Cannot construct a PostieEvent with a postMessage event object";
      }
      this.origin = event.origin;
      message = JSON.parse(event.data);
      this.uuid = message.uuid;
      this.data = message.payload;
      this.sourceWindow = event.source;
      this.respond();
      this;
    }

    PostieEvent.prototype.respond = function() {
      var sender;
      sender = new PostieSender(this.sourceWindow, this.response());
      console.log("respond...");
      console.log(sender);
      console.log(sender.frame.name);
      console.log(sender.frame.postMessage);
      return sender;
    };

    PostieEvent.prototype.response = function() {
      return {
        success: true
      };
    };

    return PostieEvent;

  })();

  PostieSender = (function() {

    PostieSender.prototype.allowedDomains = ['*'];

    PostieSender.prototype.uuid = null;

    function PostieSender(frame, data, options) {
      this.frame = frame;
      this.data = data;
      if (options == null) options = {};
      this.parseFrame();
      this.dispatch();
      if (options.callback) options.callback();
    }

    PostieSender.prototype.parseFrame = function() {
      if (typeof this.frame === 'string') {
        return this.frame = document.getElementById(this.frame);
      }
      if (typeof this.frame.contentWindow === 'object') {
        this.frame = this.frame.contentWindow;
      }
      try {
        if (typeof this.frame.postMessage === 'function') return this.frame;
      } catch (err) {
        return console.log("Could not call postMessage on: " + err);
      }
    };

    PostieSender.prototype.payload = function() {
      var message;
      try {
        message = {
          uuid: this.generateUuid(),
          payload: this.data
        };
        return JSON.stringify(message);
      } catch (err) {
        return console.log("Could not stringify data: " + this.data + " with " + err);
      }
    };

    PostieSender.prototype.dispatch = function() {
      console.log(this.frame.name);
      console.log(this.payload());
      console.log(this.domains());
      return this.frame.postMessage(this.payload(), this.domains());
    };

    PostieSender.prototype.domains = function(options) {
      var domains;
      if (options == null) options = {};
      domains = options.domains || this.allowedDomains;
      return domains.join(', ');
    };

    PostieSender.prototype.generateUuid = function() {
      var s4;
      if (this.uuid) return this.uuid;
      s4 = function() {
        return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
      };
      return this.uuid = "" + (s4()) + (s4()) + "-" + (s4()) + "-" + (s4()) + "-" + (s4()) + "-" + (s4()) + (s4()) + (s4());
    };

    return PostieSender;

  })();

}).call(this);
