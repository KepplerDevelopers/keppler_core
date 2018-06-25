$(document).ready ->
  $('#upload').click ->
    $('#upload-file').click()
    $('#upload-file').change ->
      $('.waiting').css 'display', 'block'
      $('#upload-form').submit()
      return
    return
  renderImg()
  return

$(document).on('turbolinks:load', ready_post)
