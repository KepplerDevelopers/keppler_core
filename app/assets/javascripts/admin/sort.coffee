jQuery ->
  $('#draggable').sortable
    axis: 'y'
    handler: '.drop'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
      moveDropdown()

