App.messages = App.cable.subscriptions.create('GamesChannel', {  
  received: function(data) {
    $("#open-games").removeClass('hidden')
    return $('#open-games').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
  	var content = "<ul><b>Game ID</b>:" + data.gameid + " <b>Host</b>: " + data.host + "<br><u>Players</u> " + data.numPlayers + "<br>"
  	+ "<li>" + data.host + " " + data.hostmmr + "<br><a class='btn btn-success' href='/join_game?gameid=" + data.gameid + "'>Join Game</a></ul>";
    return content;
  }
});
