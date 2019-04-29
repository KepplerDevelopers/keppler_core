$(document).on('confirm:complete', function(e, answer) {
  if (response) {
    $('.spinner').css('display', 'block');
    return answer;
  }
});
