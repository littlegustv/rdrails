App.messages = App.cable.subscriptions.create('ClientsChannel', {  
  received: function(data) {
    $("#client").removeClass('hidden')
    return $('#client').append(this.renderMessage(data));
  },
  connected: function (data) {
    // here: send login with current_user.id (token) from HERE? instead of from controller
    return $("#client").append(this.renderMessage({message: "Welcome online!"}));
  },
  renderMessage: function(data) {
    return "<p>" + data.message + "</p>";
  }
});

$(document).ready( function (e) {

  $("#redemption-form").bind("ajax:complete", function(event,xhr,status){
    $('#redemption-input').val('');
  });
  
});
