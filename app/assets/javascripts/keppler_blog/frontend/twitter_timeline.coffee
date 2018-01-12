$(document).on 'ready page:change', () ->	
  loadTwitterSDK()
 	renderTimelines

loadTwitterSDK = ->
  $.getScript "//platform.twitter.com/widgets.js", ->
    renderTimelines()

renderTimelines = ->
  $('.twitter-timeline-container').each ->
    $container = $(this)
    widgetId = $container.data 'widget-id'
    widgetOptions = $container.data 'widget-options'
    $container.empty()
    twttr?.widgets.createTimeline widgetId, $container[0], null, widgetOptions