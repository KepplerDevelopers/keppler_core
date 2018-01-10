jQuery ->
  $('#draggable').sortable
    axis: 'y'
    handler: '.draggable'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
