function notify(notice) {
  const toast = swal.mixin({
    toast: true,
    position: 'top',
    showConfirmButton: false,
    timer: 5000,
    customClass: 'animated tada'
  });

  toast({
    type: 'success',
    html: `<h5>${notice}</h5>`
  })
}
