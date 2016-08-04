//TODO 
//debug - if a player creates a game, player b joins game, player a refreshes the page and player b leaves will not update player a

App.messages = App.cable.subscriptions.create('PlayerLeaveGamesChannel', {  
  received: function(data) {
  	var location = "#players-" + data.gameid;
   return $(location).empty().append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    var content = "";
    for (i=0 ; i < data.gameplayers.length; i++){
    	content += "<li>" + data.gameplayers[i] + " " +data.gameskill[i] + "</li>";
    }
    return content;
  }
});
