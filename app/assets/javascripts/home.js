// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(':input[title]').each(function() {
  var $this = $(this);
  if($this.val() === '') {
    $this.val($this.attr('title')).css('color', "#999");
  }
  $this.focus(function() {
    if($this.val() === $this.attr('title')) {
      $this.val('').css('color', "#000");
    }
  });
  $this.blur(function() {
    if($this.val() === '') {
      $this.val($this.attr('title')).css('color', "#999");
    }
  });
});