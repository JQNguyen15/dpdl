App.messages = App.cable.subscriptions.create('GamesChannel', {  
  received: function(data) {
    $("#open-games").removeClass('hidden')
    //$('#comments ul.comments').append("<%= escape_javascript render(:partial => 'comments/single', :locals => { :c => @comment }) %>");
    return $('#open-games').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
  	var content = "<ul><b>Game ID</b>:" + data.gameid + " <b>Host</b>: " + data.host + "<br><u>Players</u> " + data.numPlayers + "<br>"
  	+ "<li>" + data.host + " " + data.hostmmr + "</ul><br>";
    return content;
  }
});
