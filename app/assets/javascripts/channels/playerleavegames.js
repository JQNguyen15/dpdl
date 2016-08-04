App.messages = App.cable.subscriptions.create('PlayerLeaveGamesChannel', {  
  received: function(data) {
  	var location = "#players-" + data.gameid;
   return $(location).empty().append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    // var content = "<li>"+ data.playername + " " + data.playerskill + "</li>";
    // return content;
    return "hello world!!";
  }
});
