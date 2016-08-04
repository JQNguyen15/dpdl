App.messages = App.cable.subscriptions.create('NumPlayerGamesChannel', {  
  received: function(data) {
  	var temp = data.numPlayers;
  	temp--;
  	var location = "#gameid-" + data.gameid + "-" + temp;
    return $(location).empty().append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    var content = "<b>"+data.numPlayers+ "</b>";
    return content;
  }
});
