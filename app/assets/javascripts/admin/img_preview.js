
function renderImg(){
  xOffset = -20;
  yOffset = 40;
  $('.show-row img').hover(function(e){
    alert('asda')
    $('body').append( "<img src=" + this.src + " alt='Image preview' class='img-show' />" );
    $('.img-show')
      .css({
        'top': (e.pageY - xOffset) + 'px',
        'left': (e.pageX + yOffset) + 'px'
      })
      .fadeIn('slow');
  }, function(){
    $('.img-show').remove();
  });
  $('.show-row img').mousemove(function(e){
    $('.img-show')
      .css({
        'top': (e.pageY - xOffset) + 'px',
        'left': (e.pageX + yOffset) + 'px'
      })
      .fadeIn('slow');
  });
}
