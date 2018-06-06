jQuery ->
  $('#objects-container').sortable
    axis: 'y'
    handle: '.drop'
    distance: 20
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
      moveDropdown()
