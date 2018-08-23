function copy(id) {
  // Crea un campo de texto "oculto"
  var aux = document.createElement("input");
  // Asigna el contenido del elemento especificado al valor del campo
  aux.setAttribute("value", $("#"+id).val());
  // Añade el campo a la página
  document.body.appendChild(aux);
  // Selecciona el contenido del campo
  aux.select();
  // Copia el texto seleccionado
  document.execCommand("copy");
  // Elimina el campo de la página
  document.body.removeChild(aux);
}

function copyPartial(id) {
  const el = document.createElement('textarea');
  el.value = $("#partial"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}

function copyHtml(id) {
  const el = document.createElement('textarea');
  el.value = $("#"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}


$(document).on('turbolinks:load', function() {

  $(document).ready(function(){
    $('#btn-assets-editor').click(function(){
      $('#assets-editor').addClass('control-sidebar-open');
      loadSave()
    })

    $('#btn-theme-editor').click(function(){
      $('#theme-editor').addClass('control-sidebar-open');
      loadSave()
    })

    $('#btn-views-editor').click(function(){
      $('#views-editor').addClass('control-sidebar-open');
      loadSave()
    })

    $('#close-assets-editor').click(function(){
      $('#assets-editor').removeClass('control-sidebar-open');
    })

    $('#close-theme-editor').click(function(){
      $('#theme-editor').removeClass('control-sidebar-open');
    })

    $('#close-views-editor').click(function(){
      $('#views-editor').removeClass('control-sidebar-open');
    })
  })

  function loadSave() {
    $(document).keypress("s",function(e) {
      if(e.ctrlKey && e.key=='s') {
        e.preventDefault();
        if ( tab === `#{@view.name}.html.erb`) {
          alert("pasooo")
          codeHTML.save(id);
        } else if (tab === `#{@view.name}.scss`) {
          codeCSS.save(id);
        } else if (tab === `#{@view.name}.js`) {
          codeJs.save(id);
        } else if (tab === 'Action') {
          codeAction.save(id);
        }
      }
    });
  }
});
