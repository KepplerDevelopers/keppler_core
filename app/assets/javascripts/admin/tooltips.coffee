$(document).on 'turbolinks:load', ->
  $('body').tooltip({
    selector: "[data-toggle~='tooltip']"
  })
