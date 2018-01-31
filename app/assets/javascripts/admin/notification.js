function notify(notice){
  new Noty({
    text: notice,
    //layout: 'topRight',
    layout: 'bottomLeft',
    timeout: 2000,
    animation: {
      open: 'animated bounceIn', // Animate.css class names
      close: 'animated flipOutX' // Animate.css class names
      // open: function (promise) {
      //   var n = this;
      //   new Bounce()

      //     // .translate({ //Road runner
      //     //   from     : {x: -500, y: 0}, to: {x: 0, y: 0},
      //     //   easing   : "bounce",
      //     //   duration : 1000,
      //     //   bounces  : 2,
      //     //   stiffness: 5
      //     // })
      //     // .skew({
      //     //   from     : {x: 0, y: 0}, to: {x: 120, y: 0},
      //     //   easing   : "sway",
      //     //   duration : 1000,
      //     //   bounces  : 4,
      //     //   stiffness: 3
      //     // })
      //     // .translate({ 
      //     //   from     : {x: 0, y: 0}, to: {x: 0, y: -50},
      //     //   easing   : "sway",
      //     //   duration : 1000,
      //     //   delay    : 800,
      //     //   bounces  : 4,
      //     //   stiffness: 2
      //     // })

      //     //////////////////////////////////////////////

      //     .translate({ //Bounce original
      //       from     : {x: -450, y: 0}, to: {x: 0, y: 0},
      //       easing   : "bounce",
      //       duration : 1000,
      //       bounces  : 4,
      //       stiffness: 3
      //     })
      //     .scale({
      //       from     : {x: 0.6, y: 0.6}, to: {x: 1, y: 1},
      //       easing   : "bounce",
      //       duration : 1000,
      //       delay    : 100,
      //       bounces  : 4,
      //       stiffness: 1
      //     })
      //     .scale({
      //       from     : {x: 1, y: 1.2}, to: {x: 1, y: 1},
      //       easing   : "bounce",
      //       duration : 500,
      //       delay    : 100,
      //       bounces  : 6,
      //       stiffness: 1
      //     })

      //     .applyTo(n.barDom, {
      //       onComplete: function () {
      //         promise(function(resolve) {
      //           resolve();
      //         })
      //       }
      //     });
      // },
      // close: function (promise) {
      //   var n = this;
      //   new Bounce()
      //     .scale({ //Bounce original
      //       from     : {x: 1, y: 1}, to: {x: 0.6, y: 0.6},
      //       easing   : "bounce",
      //       duration : 1000,
      //       bounces  : 3,
      //       stiffness: 1
      //     })
      //     .translate({ //Bounce original
      //       from     : {x: 0, y: 0}, to: {x: -500, y: 0},
      //       easing   : "bounce",
      //       duration : 1000,
      //       bounces  : 3,
      //       stiffness: 1
      //     })

      //     ///////////////////////////////////////////


      //     // .translate({ // Road runner
      //     //   from     : {x: 0, y: 0}, to: {x: -500, y: 0},
      //     //   easing   : "bounce",
      //     //   duration : 1000,
      //     //   delay    : 1000,
      //     //   bounces  : 4,
      //     //   stiffness: 3
      //     // })
      //     // .skew({
      //     //   from     : {x: 0, y: 0}, to: {x: -40, y: 0},
      //     //   easing   : "bounce",
      //     //   duration : 1000,
      //     //   delay    : 1000,
      //     //   bounces  : 4,
      //     //   stiffness: 3
      //     // })
      //     .applyTo(n.barDom, {
      //       onComplete: function () {
      //         promise(function(resolve) {
      //           resolve();
      //         })
      //       }
      //     });
      // }
    }
  }).show();
}
