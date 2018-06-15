$(window).load ->

  hidePreloader = ->
    preloader = $('#spinner')
    preloader.fadeOut preloaderFadeOutTime
    return

  toggleMenu = ->
    $slice = $('#sidebar-footer .brand')
    $slice.toggleClass 'hidden'

  $('.sidebar-toggle').click ->
    toggleMenu()

  searchButton = ->
    $('.search-button').click ->
      # if $(window).width() < 992
      if $(this).hasClass ('submit')
        $('#search form').submit()
      $('#search')
        .removeClass 'hidding-search'
        .addClass 'display-search'
      if $(window).width() < 992
        $('.navbar-custom-menu').addClass 'translate'
      $('.hide-search').addClass 'appear'
      $('.search-bar').focus()
      $(this).addClass 'submit'
      # else
      #   $('#search form').submit()


    $('.hide-search').click ->
      $('#search')
        .removeClass 'display-search'
        .addClass 'hidding-search'
      $('.navbar-custom-menu').removeClass 'translate'
      $('.hide-search').removeClass 'appear'
      $('.search-button').removeClass 'submit'

  $('.datepicker').datepicker({
    dateFormat: 'yy-mm-dd', # formato obligatorio para Keppler
    showOtherMonths: true,
    selectOtherMonths: true,
    changeMonth: true,
    changeYear: true

    # Ver documentación en https://jqueryui.com/datepicker
  })

  preloaderFadeOutTime = 500
  hidePreloader()
  searchButton()
  return
