$(document).on('confirm:complete', function(e, answer) {
  $(".spinner").css('display', 'block');
  return answer;
});
