function notify(notice, state) {
  const toast = swal.mixin({
    toast: true,
    position: 'top',
    showConfirmButton: false,
    timer: 5000,
    customClass: 'animated tada'
  });

  toast({
    type: state == 'error' ? 'error' : 'success',
    html: `<h5>${notice}</h5>`
  })
}
