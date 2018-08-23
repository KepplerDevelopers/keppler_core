function notify(notice){
  new Noty({
    text: notice,
    layout: 'bottomCenter',
    theme: 'relax', // mint, sunset, relax, nest, metroui, semanticui, light, bootstrap-v3, bootstrap-v4
    closeWith: ['click', 'button'], // ['click', 'button', 'hover', 'backdrop'] // backdrop click will close all notifications
    timeout: 2000, // [integer|boolean] delay for closing event in milliseconds. Set false for sticky notifications
    type: 'notification', // success, error, warning, information, notification
    // modal: true, // [boolean] if true adds an overlay
    killer: true, // [boolean] if true closes all notifications and shows itself
    progressBar: true, // default true
    animation: {
      open: 'animated bounceIn', // Animate.css class names
      close: 'animated flipOutX', // Animate.css class names
      easing: 'swing',
      speed: 500 // opening & closing animation speed
    }
  }).show();
}