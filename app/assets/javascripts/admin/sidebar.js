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
    $(this).css('top', 40 + (47 * idx) + "px")
  });
}
