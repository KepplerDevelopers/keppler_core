$(document).ready(function() {
  var open = false;
  $(".console").addClass('console-close');

  $(".console-btn").click(function(){
    if(open===false) {
      open = true      
      $(".console").removeClass('console-close').addClass('console-open');
    } else {
      open = false
      $(".console").removeClass('console-open').addClass('console-close');
    }
  })
})
