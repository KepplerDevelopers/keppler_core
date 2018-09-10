upload_records = ->
  $('#upload').click ->
    $('#upload-file').click()
    $('#upload-file').change ->
      $('.waiting').css 'display', 'block'
      $('#upload-form').submit()

$(document).on('turbolinks:load', upload_records)