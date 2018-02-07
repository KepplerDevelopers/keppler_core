function renderImg(){
  xOffset = -20;
  yOffset = 40;
  $('.show-row img').hover(function(e){
    $( "body" ).append( "<p id='preview'><img src='"+ this.src +"' alt='Image preview' class='img-show' /></p>" );
    $("#preview")
      .css("top",(e.pageY - xOffset) + "px")
      .css("left",(e.pageX + yOffset) + "px")
      .fadeIn("slow");
  }, function(){
    $("#preview").remove();
  });
  $(".show-row img").mousemove(function(e){
    $("#preview")
      .css("top",(e.pageY - xOffset) + "px")
      .css("left",(e.pageX + yOffset) + "px");
  });
}
