file_uploader = ->

  $files = []
  $fileNames = []
  $fileUploader = $ '.file-uploader'
  $fileContainer = $ '.file-container'
  $fileInput = $ '.file-uploader input:file'
  $fileIcon = $ '.file-icon'
  $fileText = $ '.file-text'

  if $fileInput.attr('multiple') != undefined
    $fileUploader.prepend '<ul class="file-list"></ul>'
    $fileUploader.addClass 'file-multiple'
    $fileList = $('.file-uploader .file-list')
    $fileList.append $fileContainer
  else
    $fileContainer.append '<p class="file-name"></p>'

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
    reader.onload = (e) ->
      for k, f of files
        console.log f
        continue if typeof f isnt 'object' and f.toString() isnt '[object File]'
        continue if -1 isnt $fileNames.indexOf f.name
        $files.push f
        $fileNames.push f.name
        # $fileList.append "<li>#{f.name} (#{calcSize f.size}) - #{f.type || 'unknown'}</li>"
        items = $('.file-item').length
        $fileContainer.before "
          <li id='file-item-#{items}' class='file-item'
            data-toggle='tooltip'
            data-original-title='#{f.name} (#{calcSize f.size}) - #{f.type || 'unknown'}'>
          </li>
        "
        fileItem = $ "#file-item-#{items}"
        fileItem.append "
          <div id='file-item-background-#{items}' class='file-item-background'></div>
        "
        fileItem.append "
          <i id='file-icon-delete-#{items}'
          class='file-icon-delete icon-close item-opacity'></i>
        "
        fileBackground = $ "#file-item-background-#{items}"
        console.log items
        if f.type.includes? 'image'
          fileBackground.css {
            'background-image': "url(#{e.target.result})"
          }
        # else if f.name.includes('.rocket') # Only for rockets
        #   fileBackground.addClass 'icon-rocket'
        else if f.type.includes? 'audio'
          fileBackground.append "<i class='icon-music-tone-alt'></i>"
        else if f.type.includes? 'video'
          fileBackground.append "<i class='icon-film'></i>"
        else if f.type.includes? 'application'
          fileBackground.append "<i class='icon-notebook'></i>"
        else if f.type.includes? 'text'
          fileBackground.append "<i class='icon-doc'></i>"
        else if f.type.includes? 'font'
          fileBackground.append "<i class='icon-emotsmile'></i>"
        else
          fileBackground.append "<i class='icon-question'></i>"

      deleteItem = (icon) ->
        id = icon.id.split('-')[3]
        # Remove file icon tooltip
        $ "##{$('#file-icon-delete-' + id).attr('aria-describedby')}"
          .remove()
        # Remove file tooltip
        $ "##{$('#file-item-' + id).attr('aria-describedby')}"
          .remove()
        # Remove object from DOM
        $ "#file-item-#{id}"
          .remove()
        # Remove file from $files
        filePos = $files.indexOf $files[id]
        $files.splice(filePos, 1)
        # Remove fileName from $fileNames
        namePos = $fileNames.indexOf $fileNames[id]
        $fileNames.splice(namePos, 1)
        # console.table $files
        # console.table $fileNames

      $ '.file-icon-delete'
        .click ->
          deleteItem(this)

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

