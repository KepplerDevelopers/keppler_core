$(document).ready ->
  window['rangy'].initialized = false

  $('.wysihtml5').wysihtml5 {
    # toolbar: {
    #   'fa': false
    #   'icon': true
    #   'font-styles': true
    #   'color': true
    #   'emphasis': { 'small': true }
    #   'blockquote': true
    #   'lists': true
    #   'html': false
    #   'link': true
    #   'image': true
    #   'smallmodals': true
    # }
  }

window.getSelection().removeAllRanges()
