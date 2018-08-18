$(document).on('turbolinks:load', function() {
  $(function ($) {
    $('.delete').click(function(e){
      e.preventDefault()
      swal({
        title: 'Submit your Github username',
        input: 'text',
        inputAttributes: {
          autocapitalize: 'off'
        },
        showCancelButton: true,
        confirmButtonText: 'Look up',
        showLoaderOnConfirm: true,
        preConfirm: (login) => {
          return fetch(`//api.github.com/users/${login}`)
            .then(response => {
              if (!response.ok) {
                throw new Error(response.statusText)
              }
              return response.json()
            })
            .catch(error => {
              swal.showValidationError(
                `Request failed: ${error}`
              )
            })
        },
        allowOutsideClick: () => !swal.isLoading()
      }).then((result) => {
        if (result.value) {
          swal({
            title: `${result.value.login}'s avatar`,
            imageUrl: result.value.avatar_url
          })
        }
      })
    })
  });
});
