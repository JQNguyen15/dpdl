

//TODO : if a player joins aother persons game and then the other person deletes their game the create game button doesn't reappear
//unable to fix this unless ... redirect in here to root? simple fix for now
App.messages = App.cable.subscriptions.create('DestroyGameChannel', {
  received: function(data) {
     window.location.href = "/";
  //	var location = "#" + data.gameid;
   //return $(location).empty();
  }
});
