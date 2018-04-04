function moveDropdown(){
  $('.action-btn').click(function(e){
    var that = this;
    let a = $(`ul[aria-labelledby='${that.id}']`)[0];
    let b = $(that).offset().top;
    if ($(document).width() > 767) {
      $(a).css("top",(b - 122) + "px");
    } else {
      $(a).css("top",(b - 192) + "px");
    }
  });
}
