App.messages = App.cable.subscriptions.create('GamesChannel', {
  received: function(data) {
    $("#open-games").removeClass('hidden')
    return $('#open-games').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
	var content = "<div id ='" + data.gameid + "'><ul><b>Game ID</b>:" + data.gameid + " <b>Host</b>: " + data.host + "<br><u>Players</u> " +"<b><div id='gameid-" + data.gameid + "-" + data.numPlayers +"'>" + data.numPlayers + "</b></div><br>"
  	+ "<div id='players-" +data.gameid + "'><li>" + data.host + " " + data.hostmmr + "</li></div><br><a class='btn btn-success' href='/join_game?gameid=" + data.gameid + "'>Join Game</a></ul></div>";

    return content;
  }
});
