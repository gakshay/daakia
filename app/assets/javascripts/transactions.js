//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function() {
  $("#mobile_toggle").click(function(){
	if($(this).text() == "Mobile"){
		$(this).text("Email");
	}else{
		$(this).text("Mobile");
	}
    $("#receiver_mobile").toggle();
	$("#receiver_email").toggle();
  });
});