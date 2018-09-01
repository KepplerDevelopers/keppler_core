file_uploader = ->

  $files = []
  $fileNames = []
  $fileUploader = $ '.file-uploader'
  $fileContainer = $ '.file-container'
  $fileInput = $ '.file-uploader input[type=file]'
  $fileIcon = $ '.file-icon'

  initialize = ->
    if $fileInput.attr('multiple') != undefined
      $fileUploader.append '<ul class="file-list"></ul>'
    else
      $fileContainer.append '<p class="file-name"></p>'
  
  initialize()

  calcSize = (size) ->
    sizeMap = {
      1: 'B'
      2: 'KB'
      3: 'MB'
      4: 'GB'
    }
    i = 1
    while size > 999.99
      size = size / 1024
      i++
    size.toFixed(2) + ' ' + sizeMap[i]

  # Display the file to be uploaded.
  $fileInput.on 'change', (e) ->
    $fileContainer.css 'background', 'none'
    $fileContainer.children().removeClass 'opacity'
    readURL(this)

  readURL = (input) ->
    files = input.files
    if (files && files[0])
      reader = new FileReader()
      if $fileInput.attr('multiple') != undefined
        multiFile(reader, files)
      else
        justOneFile(reader, files)
    reader.readAsDataURL(files[0])
  
  multiFile = (reader, files) ->
    $fileList = $('.file-uploader .file-list')
    for k, f of files
      continue if typeof f isnt 'object' and f.toString() isnt '[object File]'
      continue if -1 isnt $fileNames.indexOf f.name
      $files.push f
      $fileNames.push f.name
      # $fileList.append "<li>#{f.name} (#{calcSize f.size}) - #{f.type || 'unknown'}</li>"
      items = $fileList.children().length
      $fileList.append "
        <li id='file-item-#{items}'
          data-toggle='tooltip'
          data-original-title='#{f.name} (#{calcSize f.size}) - #{f.type || 'unknown'}'>
        </li>
      "
      fileItem = $ "#file-item-#{items}"
      # if rocketType # Only for rockets
      #   fileItem.addClass 'icon-rocket'
      if f.type.includes? 'image'
        fileItem.append '<i class="icon-picture"></i>'
      else if f.type.includes? 'audio'
        fileItem.append '<i class="icon-music-tone-alt"></i>'
      else if f.type.includes? 'video'
        fileItem.append '<i class="icon-film"></i>'
      else if f.type.includes? 'application'
        fileItem.append '<i class="icon-notebook"></i>'
      else if f.type.includes? 'text'
        fileItem.append '<i class="icon-doc"></i>'
      else if f.type.includes? 'font'
        fileItem.append '<i class="icon-emotsmile"></i>'
      else
        fileItem.append '<i class="icon-question"></i>'

  justOneFile = (reader, files) ->
    f = files[0]
    rocketType = 'KepplerRocket' if f.name.includes('.rocket') # Only for rockets
    $ '.file-container .file-name'
      .text "#{f.name} (#{calcSize f.size}) - #{rocketType || f.type || 'unknown'}"
    
    # File Icon
    $fileIcon.removeClass().addClass 'file-icon'
    if rocketType # Only for rockets
      $fileIcon.addClass 'icon-rocket'
    else if f.type.includes? 'image'
      $fileIcon.addClass 'icon-picture'
    else if f.type.includes? 'audio'
      $fileIcon.addClass 'icon-music-tone-alt'
    else if f.type.includes? 'video'
      $fileIcon.addClass 'icon-film'
    else if f.type.includes? 'application'
      $fileIcon.addClass 'icon-notebook'
    else if f.type.includes? 'text'
      $fileIcon.addClass 'icon-doc'
    else if f.type.includes? 'font'
      $fileIcon.addClass 'icon-emotsmile'
    else
      $fileIcon.addClass 'icon-question'

    reader.onload = (e) ->
      if f.type.includes 'image'
        $('.file-container').css {
          'background-image': "url(#{e.target.result})"
          'background-position': 'center'
          'background-size': 'contain',
          'background-repeat': 'no-repeat'
        }
        $('.file-container').children()
          .not($fileInput).addClass 'opacity'

  showSpinner = ->
    $ '.spinner'
      .css 'display', 'block'

  #Only for rockets
  installRocket = (evt) ->
    evt.preventDefault()
    rocket_file = $fileInput.val()
    can_install = true
    if rocket_file isnt ''
      if rocket_file.includes('.rocket')
        $('.rocket-name').each ->
          if rocket_file.includes $(this).text()
            swal 'That rocket is already installed :('
            can_install = false
        if can_install
          showSpinner()
          $ 'form'
            .submit()
      else
        swal 'Houston! That file isn\'t a rocket :('
    else
      swal 'First upload a rocket please!'

  $('#installRocket').on 'click', installRocket

$(document).on('turbolinks:load', file_uploader)

