(function() {
  var Postie;

  Postie = (function() {

    Postie.prototype.listen = null;

    function Postie() {}

    Postie.prototype.send = function(frame, data, callback) {
      return console.log(frame);
    };

    Postie.prototype.listen = function(callback) {
      this.listenCallback = callback;
      return this.bindEventListener;
    };

    Postie.prototype.onMessage = function(event) {
      console.log(event);
      return this.listenCallback(event);
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

}).call(this);
