jQuery ->
  $('#draggable').sortable
    axis: 'y'
    handler: '.drag'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))