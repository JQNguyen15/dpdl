App.messages = App.cable.subscriptions.create('PlayerGamesChannel', {  
  received: function(data) {
    $("#display-players").removeClass('hidden')
   // return $('#display-players').append(this.renderMessage(data));
   return $('#display-players').append(this.renderMessage(data));
  },

  renderMessage: function(data) {
    var content = "<li>"+ data.playername + " " + data.playerskill + "</li>";
    return content;
  }
});
