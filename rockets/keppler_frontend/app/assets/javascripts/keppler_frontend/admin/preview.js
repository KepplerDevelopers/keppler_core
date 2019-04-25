$(document).ready(function() {
  $('#xs').click(function() {
    $('#box-body').animate({ 'width': '35%' }, 300)
  })

  $('#md').click(function() {
    $('#box-body').animate({ 'width': '70%' }, 300)
  })

  $('#lg').click(function() {
    $('#box-body').animate({ 'width': '100%' }, 300)
  })

  $('#reload').click(function() {
    var url = document.getElementById("preview").contentWindow.location.href
    $('iframe').attr('src', url)
  })
});