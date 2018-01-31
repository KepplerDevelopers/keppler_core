Keppler = $('#keppler .front-logo')
Social = $('#keppler .front-social')
Slice = $('#keppler .front-footer')
Mouse = $('#keppler .mouse-scroll')
function scrollFunction(){
  scroll = $(window).scrollTop()
  if (scroll <= 559) {
    $('.front').css({
      position: 'relative',
      top: 0,
      height: '616px'
    })
    // Keppler.css({
    // 	transform: 'translate(0%, -186.96px) scale(0.3328)'
    // })
    Social.css({
      display: 'inline',
      opacity: 1
    })
    Slice.css({
      display: 'inline',
      opacity: 1
    })
    Mouse.css({
      display: 'block',
      opacity: 1
    })
    // $('#documentation').css({
    // 	'margin-top': '100vh'
    // })
    if (scroll <= 10) {
      Keppler.css({
        transform: 'scale(1)'
      })
      Social.css('opacity', '1')
      Slice.css({
        opacity: 1,
        transform: 'scale(1)'
      })
    }
    if (scroll > 10 && scroll <= 60) {
      Keppler.css({
        transform: 'scale('+(1-('0.'+scroll)*0.1)+')'
      })
      Social.css('opacity', 1-('0.'+scroll))
      Mouse.css('opacity', 1-('0.'+scroll))
      Slice.css({
        opacity: 1-('0.'+scroll),
        transform: 'scale('+(1-('0.'+scroll))+')'
      })
    }
    if (scroll > 60 && scroll <= 99) {
      Keppler.css({
        transform: 'scale('+(1-('0.'+scroll)*0.1)+')'
      })
      Social.css('opacity', 1-('0.'+scroll))
      Mouse.css('opacity', 1-('0.'+scroll))
      Slice.css({
        opacity: 1-('0.'+scroll),
        transform: 'scale('+(1-('0.'+scroll))+')'
      })
    }
    if (scroll > 99 && scroll <= 559) {
      Keppler.css({
        transform: 'translate(0%, -'+(scroll-(100))*0.41+'px) scale('+(1-('0.'+scroll)*1.2)+')'
      })
      Social.css({
        display: 'none',
        opacity: 0
      })
      Mouse.css({
        display: 'none',
        opacity: 0
      })
      Slice.css({
        display: 'none',
        opacity: 0
      })
    }
    $('#documentation').css({
      'margin-top': '0',
      position: 'relative'
    })
  }
  else {
    $('.front').css({
      position: 'fixed',
      width: '100%',
      top: '-554.4px'
    })
    Keppler.css({
      transform: 'translate(0%, -186.96px) scale(0.3328)'
    })
    Social.css({
      display: 'none',
      opacity: 0
    })
    Mouse.css({
      display: 'none',
      opacity: 0
    })
    Slice.css({
      display: 'none',
      opacity: 0
    })
    $('#documentation').css({
      'margin-top': '616px'
    })
  }
  // console.log(scroll)
}
$(document).ready(function() {
  $('pre code').each(function(i, block) {
    // hljs.highlightBlock(block);
  });
  scrollFunction()
  Mouse = $('.mouse-scroll')
  Mouse.click(function(){
    for(i=0;i<616;i++) {
      setTimeout(function(){
        $('html').scrollTop(i);
      }, 200)
    }
  })
});

$( window ).scroll(function() {
  scrollFunction()
})
