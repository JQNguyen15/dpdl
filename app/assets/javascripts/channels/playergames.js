
App.messages = App.cable.subscriptions.create('PlayerGamesChannel', {  
  received: function(data) {
  	var location = "#players-" + data.gameid;
    return $(location).append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    var content = "<li>"+ data.playername + " " + data.playerskill + "</li>";
    return content;
  }
});
