$(document).on('turbolinks:load', function() {
  $(document).ready(function() {
    $('#xs').click(function() {
      $('.iframe-body').animate({ 'width': '35%' }, 300)
    })

    $('#md').click(function() {
      $('.iframe-body').animate({ 'width': '70%' }, 300)
    })

    $('#lg').click(function() {
      $('.iframe-body').animate({ 'width': '100%' }, 300)
    })

    $('#reload').click(function() {
      $('iframe').attr('src', '/')
    })

    $('#customize-index .icon-trash').click(function() {
      $('.spinner').css('display', 'block')
    })
  });
});
