App.messages = App.cable.subscriptions.create('DestroyGameChannel', {
  received: function(data) {
     window.location.href = "/";
  }
});
