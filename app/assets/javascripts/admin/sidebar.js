$(function ($) {
  var $body = $('body'),
      $slice = $('#sidebar-footer .brand')
  // On click, capture state and save it in localStorage
  $($.AdminLTE.options.sidebarToggleSelector).click(function () {
    localStorage.setItem('sidebar', $body.hasClass('sidebar-collapse') ? 1 : 0);
  });

  // On ready, read the set state and collapse if needed
  if (localStorage.getItem('sidebar') === '0') {
    $body.addClass('disable-animations sidebar-collapse');
    $slice.toggleClass('hidden')
    requestAnimationFrame(function () {
      $body.removeClass('disable-animations');
    });
  }


});
function moveDropdown(){
  var dropdown = $(".actions.dropdown-menu");
  dropdown.each(function(idx){
    $(this).css('top', 40 + (40 * idx) + "px")
  });
}
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
