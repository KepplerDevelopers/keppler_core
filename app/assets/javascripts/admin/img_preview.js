function renderImg(){
  xOffset = 20; // separacion de la imagen con respecto al puntero en X
  yOffset = 20; // separacion de la imagen con respecto al puntero en Y
  imgMargin = 50; // separacion de la imagen con respecto al borde de la pantalla
  $('.box-body img').hover(function(e){
    $('body').append( "<img src=" + this.src + " alt='No existe ruta para esta imagen' class='img-show' />" );
    xImgOffset = $(window).width() - ($('.img-show').width() + imgMargin);
    yImgOffset = $(window).height() - ($('.img-show').height() + imgMargin); // breakpoint para que la imagen siempre esté visible en la pantalla
    $('.img-show')
      .css({
        'left': ((e.pageX < xImgOffset ? e.pageX : (e.pageY < yImgOffset ? xImgOffset : (e.pageX-($('.img-show').width() + imgMargin)))) + xOffset) + 'px',
        'top': ((e.pageY < yImgOffset ? e.pageY : (yImgOffset)) + yOffset) + 'px'
      })
  }, function(){
    $('.img-show').remove();
  });
  $('.box-body img').mousemove(function(e){
    $('.img-show')
      .css({
        'left': ((e.pageX < xImgOffset ? e.pageX : (e.pageY < yImgOffset ? xImgOffset : (e.pageX-($('.img-show').width() + imgMargin)))) + xOffset) + 'px',
        'top': ((e.pageY < (yImgOffset) ? e.pageY : (yImgOffset)) + yOffset) + 'px'
      })
  });
}
