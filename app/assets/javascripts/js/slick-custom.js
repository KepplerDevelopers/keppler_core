//Carrusel de servicios en el index.html
$('#carrusel').slick({
  centerMode: true,
  centerPadding: '550px',
  slidesToShow: 1,
  autoplay: true,
  autoplaySpeed: 4000,
  arrows: true,
  prevArrow: $('#izquierdo'),
  nextArrow: $('#derecho'),
  responsive: [
    {
      breakpoint: 1681,
      settings: {
        arrows: true,
        centerMode: true,
        centerPadding: '450px',
        slidesToShow: 1
      }
    },
    {
      breakpoint: 1501,
      settings: {
        arrows: true,
        centerMode: true,
        centerPadding: '350px',
        slidesToShow: 1
      }
    },
    {
      breakpoint: 1025,
      settings: {
        arrows: false,
        centerMode: true,
        centerPadding: '200px',
        slidesToShow: 1
      }
    },
    {
      breakpoint: 768,
      settings: {
        arrows: false,
        centerMode: true,
        centerPadding: '40px',
        slidesToShow: 1
      }
    },
    {
      breakpoint: 480,
      settings: {
        arrows: false,
        centerMode: true,
        centerPadding: '40px',
        slidesToShow: 1
      }
    }
  ]
});

//Carrusel casos de exito en el index.html
$('#exito-carrusel').slick({
  dots: false,
  infinite: true,
  speed: 500,
  fade: true,
  cssEase: 'linear',
  slidesToShow: 1,
  arrows: true,
  prevArrow: $('.previo'),
  nextArrow: $('.siguiente'),
  adaptiveHeight: true
});

//Carrusel Contactos
$('.contactos-img2-carrusel').slick({
  dots: true,
  infinite: true,
  speed: 300,
  slidesToShow: 1,
  arrows: false,
  adaptiveHeight: true
});

//Carrusel Branding
$('.clientes-branding').slick({
  arrows: false,
  dots: false,
  autoplay: true,
  autoplaySpeed: 3000,
  infinite: true,
  slidesToShow: 5,
  slidesToScroll: 3,
  responsive: [
    {
      breakpoint: 1024,
      settings: {
        slidesToShow: 3,
        slidesToScroll: 3,
        infinite: true,
        dots: true
      }
    },
    {
      breakpoint: 600,
      settings: {
        slidesToShow: 2,
        slidesToScroll: 2
      }
    },
    {
      breakpoint: 480,
      settings: {
        slidesToShow: 1,
        slidesToScroll: 1
      }
    }
    
  ]
});

//Carrusel Briefing
$('.briefing-carrusel').slick({
  dots: false,
  infinite: false,
  speed: 500,
  slidesToShow: 5,
  slidesToScroll: 1,
  arrows: true,
  prevArrow: $('#flecha-izq'),
  nextArrow: $('#flecha-der'),
  responsive: [
    {
      breakpoint: 1024,
      settings: {
        slidesToShow: 3,
        slidesToScroll: 3,
        infinite: true,
        dots: true
      }
    },
    {
      breakpoint: 600,
      settings: {
        slidesToShow: 2,
        slidesToScroll: 2
      }
    },
    {
      breakpoint: 480,
      settings: {
        slidesToShow: 2,
        slidesToScroll: 2
      }
    }
    
  ]
});