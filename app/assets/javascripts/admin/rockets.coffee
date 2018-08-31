$files = []
$fileNames = []

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

processFiles = (files) ->
  if files
    fileList = $ '#fileList'
    for k, f of files
      continue if typeof f isnt 'object' and f.toString() isnt '[object File]'
      $files.push f
      $fileNames.push f.name
      if $('.file-drop input[type=file]').attr('multiple') != undefined
        continue if -1 isnt $fileNames.indexOf f.name
        fileList.append "<li>#{f.name} (#{calcSize f.size}) - #{f.type || 'unknown'}</li>"
        return false
      else
        isRocket = f.name.includes('.rocket')
        rocketType = 'KepplerRocket' if isRocket
        $ '.file-drop .file-drop-target p'
          .text "#{f.name} (#{calcSize f.size}) - #{rocketType || f.type || 'unknown'}"
          return isRocket
  return

handleDrop = (evt) ->
  evt.preventDefault()
  files = evt.originalEvent.dataTransfer.files
  processFiles files
  return

handleDragOver = (evt) ->
  evt.preventDefault()
  evt.originalEvent.dataTransfer.dropEffect = 'copy'
  return

handleFileInput = (evt) ->
  processFiles evt.target.files

clearFiles = ->
  $ '.file-drop #fileList'
    .empty()
    $files = []
    $fileNames = []
  return

showSpinner = ->
  $ '.spinner'
    .css 'display', 'block'
  return

installRocket = (evt) ->
  evt.preventDefault()
  rocket_file = $('.file-drop input[type=file]').val()
  can_install = true
  console.log rocket_file == ''
  if rocket_file isnt ''
    if rocket_file.includes('.rocket')
      $('.rocket-name').each ->
        if rocket_file.includes $(this).text()
          alert 'This rocket is already installed :('
          can_install = false
      if can_install
        $ 'form'
          .submit()
        showSpinner()
    else
      alert 'Houston! That file isn\'t a rocket :('
  else
    alert 'Please upload a rocket!'

$ document
.ready ->

  $container = $ '.file-drop'
  $input = $ '.file-drop input[type=file]'
  $target = $ '.file-drop .file-drop-target'
  $rocketInstaller = $ '.file-drop #installRocket'
  $rocketUninstaller = $ '.uninstallRocket'

  if $input.attr('multiple') != undefined
    $container
      .append(
        '<button class="clearListButton">
          <i class="icon-trash"></i>
          <span>Clear list</span>
        </button>
        <ul id="fileList"></ul>'
      )
  else
    $target.append('<p></p>')
  
  $clearListButton = $ '.file-drop .clearListButton'

  $target
    .on 'drop', handleDrop
    .on 'dragover', handleDragOver

  $input
    .on 'change', handleFileInput

  $clearListButton
    .on 'click', clearFiles

  $rocketInstaller
    .on 'click', installRocket

  $rocketUninstaller
    .on 'click', uninstallRocket

  return