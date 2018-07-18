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

ready_post = ->
  # Display the image to be uploaded.
  $('.photo-upload').on 'change', (e) ->
    readURL(this);

  readURL = (input) ->
    if (input.files && input.files[0])
      reader = new FileReader()

    reader.onload = (e) ->
      $('.image-to-upload').attr('src', e.target.result).removeClass('hidden');
      $swap = $('.swap')
      if $swap
        $swap.removeClass('hidden')
        $('.files').addClass('files-absolute')

    reader.readAsDataURL(input.files[0]);


$(document).ready(ready_post)
$(document).on('turbolinks:load', ready_post)
