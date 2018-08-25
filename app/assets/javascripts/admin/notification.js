function notify(notice){
  const toast = swal.mixin({
    toast: true,
    position: 'bottom',
    showConfirmButton: false,
    timer: 300000,
    grow: 'fullscreen'
  });

  toast({
    type: 'success',
    title: notice
  })
}