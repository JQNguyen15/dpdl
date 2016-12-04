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
    var content = "<div id ='" + data.gameid + "'><ul><b>Game ID</b>:" + data.gameid + " <b>Host</b>: " + data.host + "<br><u>Players</u> " +"<b><div id='gameid-" + data.gameid + "-" + data.numPlayers +"'>" + data.numPlayers + "</b></div><br>"
    + "<div id='players-" +data.gameid + "'><li>" + data.host + " " + data.hostmmr + "</li></div><br><a class='btn btn-success' href='/join_game?gameid=" + data.gameid + "'>Join Game</a></ul></div>";
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
	  var temp = data.numPlayers;
    if (data.upOrDown == true){
  	  temp--;
    }
    var content = "<b>"+data.numPlayers+ "</b>";
  	var location = "#gameid-" + data.gameid + "-" + temp;
    return $(location).empty().append(content);
  },

  joinGame: function(data) {
  	var location = "#players-" + data.gameid;
    var content = "<li>"+ data.playername + " " + data.playerskill + "</li>";
    return $(location).append(content);
  }
});
