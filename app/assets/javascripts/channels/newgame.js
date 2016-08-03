App.messages = App.cable.subscriptions.create('GamesChannel', {  
  received: function(data) {
    $("#open-games").removeClass('hidden')
    return $('#open-games').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    return "<p> <b>" + data.gameid + ": </b>" + data.host + "</p>";
  }
});
