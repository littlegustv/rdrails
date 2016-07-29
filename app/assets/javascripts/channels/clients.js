App.messages = App.cable.subscriptions.create('ClientsChannel', {  
  received: function(data) {
    $("#client").removeClass('hidden')
    return $('#client').append(this.renderMessage(data));
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
