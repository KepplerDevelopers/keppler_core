$(document).ready ->
  $('#upload').click ->
    $('#upload_file').click()
    $('#upload_file').change ->
      $('.waiting').css 'display', 'block'
      $('#upload_form').submit()
      return
    return
  renderImg()
  return
