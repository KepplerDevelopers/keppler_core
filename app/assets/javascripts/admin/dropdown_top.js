function moveDropdown(){
  var dropdown = $(".actions.dropdown-menu");
  dropdown.each(function(idx){
    $(this).css('top', 40 + (40 * idx) + "px")
  });
}
