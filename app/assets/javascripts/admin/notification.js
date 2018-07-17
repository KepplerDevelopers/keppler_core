function notify(notice){
  new Noty({
    text: notice,
    layout: 'bottomCenter',
    timeout: 2000,
    animation: {
      open: 'animated bounceIn', // Animate.css class names
      close: 'animated flipOutX' // Animate.css class names
    }
  }).show();
}
