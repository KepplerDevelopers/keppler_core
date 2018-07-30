//
$(document).ready(function(){
  var i = 0;
  $('#run-progress').click(function(){
    if(i==0) {
      $('#progress-friend').animate({
      	width: '100%'
      }, 2000, function() {
        $('#progress-friend').html('100%');
      });
      i = 1;
    } else {
      $('#progress-friend').animate({
      	width: '0%'
      }, 2000, function() {
        $('#progress-friend').html('0%');
      });
      i = 0;
    }
  });
});
