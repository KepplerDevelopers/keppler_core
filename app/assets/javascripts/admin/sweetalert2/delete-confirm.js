//Override the default confirm dialog by rails
$.rails.allowAction = function(link){
  if (link.data("confirm") == undefined){
    return true;
  }
  $.rails.showConfirmationDialog(link);
  return false;
}

//User click confirm button
$.rails.confirmed = function(link){
  link.data("confirm", null);
  // Turbolinks.visit(link.attr('href'))
  link.trigger("click.rails");
}

//Display the confirmation dialog
$.rails.showConfirmationDialog = function(link){
  var message = link.data("confirm");
  swal({
    title: message,
    type: 'warning',
    showCancelButton: true
  }).then((result) => {
    if (result.value) {
      $('.spinner').fadeIn();
      $.rails.confirmed(link);
    }
  });
};

var sweetAlertConfirmConfig = sweetAlertConfirmConfig || {}; // Add default config object

(function ($) {
  var sweetAlertConfirm = function (event) {

    swalDefaultOptions = {
      title: sweetAlertConfirmConfig.title || 'Are you sure?',
      type: sweetAlertConfirmConfig.type || 'warning',
      showCancelButton: sweetAlertConfirmConfig.showCancelButton || true,
      confirmButtonText: sweetAlertConfirmConfig.confirmButtonText || "Ok",
      cancelButtonText: sweetAlertConfirmConfig.cancelButtonText || "Cancel"
    }
    if (sweetAlertConfirmConfig.confirmButtonColor !== null) {
      swalDefaultOptions.confirmButtonColor = sweetAlertConfirmConfig.confirmButtonColor
    }

    $linkToVerify = $(this);
    var swalOptions = swalDefaultOptions;
    var optionKeys = [
      'text',
      'showCancelButton',
      'confirmButtonColor',
      'cancelButtonColor',
      'confirmButtonText',
      'cancelButtonText',
      'html',
      'imageUrl',
      'allowOutsideClick',
      'customClass'
    ];

    function sweetAlertConfirmedCallback() {
      if ($linkToVerify.data().remote === true) {
        $.rails.handleRemote($linkToVerify)
      } else if ($linkToVerify.data().method !== undefined) {
        $.rails.handleMethod($linkToVerify);
      } else {
        if ($linkToVerify.attr('type') == 'submit') {
          var name = $linkToVerify.attr('name'),
            data = name ? {
              name: name,
              value: $linkToVerify.val()
            } : null;
          $linkToVerify.closest('form').data('ujs:submit-button', data);
          $linkToVerify.closest('form').submit();
        } else {
          $linkToVerify.data('swal-confirmed', true).click();
        }
      }
    }

    if ($linkToVerify.data('swal-confirmed')) {
      $linkToVerify.data('swal-confirmed', false);
      return true;
    }

    $.each($linkToVerify.data(), function (key, val) {
      if ($.inArray(key, optionKeys) >= 0) {
        swalOptions[key] = val;
      }
    });

    if ($linkToVerify.attr('data-sweet-alert-type')) {
      swalOptions['type'] = $linkToVerify.attr('data-sweet-alert-type');
    }

    message = $linkToVerify.attr('data-sweet-alert-confirm')
    swalOptions['title'] = message
    swal(swalOptions).then(sweetAlertConfirmedCallback, function (dismiss) {
      return true;
    });

    return false;
  }

  $(document).on('ready turbolinks:load page:update ajaxComplete', function () {
    $('[data-sweet-alert-confirm]').on('click', sweetAlertConfirm)
  });

  $(document).on('ready turbolinks:load page:load', function () {
    //To avoid "Uncaught TypeError: Cannot read property 'querySelector' of null" on turbolinks
    if (typeof window.sweetAlertInitialize === 'function') {
      window.sweetAlertInitialize();
    }
  });

})(jQuery);