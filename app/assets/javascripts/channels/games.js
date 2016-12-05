App.messages = App.cable.subscriptions.create('GamesChannel', {
  received: function(data) {
    switch (data.action) {
      case 'create':
        this.createGame(data);
        break;
      case 'leave':
        this.leaveGame(data);
        break;
      case 'join':
        this.joinGame(data);
        break;
      case 'updateNumberOfPlayers':
        this.updateNumberOfPlayers(data);
        break;
      case 'destroy':
        this.refreshPage(data);
        break;
      case 'end':
        this.refreshPage(data);
        break;
    }
  },

  createGame: function(data) {
    $("#open-games").removeClass('hidden');
    var content = "<div id ='" + data.game.id + "'><ul><b>Game ID</b>:" + data.game.id + " <b>Host</b>: " + data.host.nickname + "<br><u>Players</u> " +"<b><div id='gameid-" + data.game.id + "'>" + data.game.players.length + "</b></div><br>"
    + "<div id='players-" + data.game.id + "'><li>" + data.host.nickname + " " + data.host.skill + "</li></div><br><a class='btn btn-success' href='/join_game?gameid=" + data.game.id + "'>Join Game</a></ul></div>";
    return $('#open-games').append(content);
  },

  refreshPage: function(data) {
     window.location.href = "/";
  },

  leaveGame: function(data) {
    var location = "#players-" + data.gameid;
    var content = "";
    for (i=0 ; i < data.gameplayers.length; i++) {
      content += "<li>" + data.gameplayers[i] + " " +data.gameskill[i] + "</li>";
    }
    return $(location).empty().append(content);
  },

  updateNumberOfPlayers: function(data) {
    var content = "<b>" + data.game.players.length + "</b>";
    var location = "#gameid-" + data.game.id
    return $(location).empty().append(content);
  },

  joinGame: function(data) {
    var location = "#players-" + data.gameid;
    var content = "<li>"+ data.playername + " " + data.playerskill + "</li>";
    return $(location).append(content);
  }
});
