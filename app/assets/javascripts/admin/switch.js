$('.keppler-switch').click(function(event) {
  event.preventDefault()
  $(this).find('input')
    .toggleClass('active')
    .attr('checked', $(this).find('input').hasClass('active'))
})
