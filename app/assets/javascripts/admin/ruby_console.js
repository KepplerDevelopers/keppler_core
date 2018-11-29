$( document ).on('turbolinks:load', function() {
  var open = false;
  

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
