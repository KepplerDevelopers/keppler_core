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
      continue if -1 isnt $fileNames.indexOf f.name
      $files.push f
      $fileNames.push f.name
      if $('.inputAddFiles').attr('multiple') != undefined
        fileList.append "<li>#{f.name} (#{calcSize f.size}) - #{f.type || 'unknown'}</li>"
        return false
      else
        isRocket = f.name.includes('.rocket')
        rocketType = 'KepplerRocket' if isRocket
        $ '.fileDropTarget p'
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
  $ '.fileDrop #fileList'
    .empty()
    $files = []
    $fileNames = []
  return

installRocket = ->
  $ '.fileDrop #fileList'
    .empty()
    $files = []
    $fileNames = []
  return
  

$ document
.ready ->

  $container = $ '.fileDrop'
  $input = $ '.fileDrop .inputAddFiles'
  $target = $ '.fileDrop .fileDropTarget'

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
  
  $clearListButton = $ '.fileDrop .clearListButton'

  $target
    .on 'drop', handleDrop
    .on 'dragover', handleDragOver

  $input
    .on 'change', handleFileInput

  $clearListButton
    .on 'click', clearFiles

  $installRocket
    .on 'click', installRocket
  return