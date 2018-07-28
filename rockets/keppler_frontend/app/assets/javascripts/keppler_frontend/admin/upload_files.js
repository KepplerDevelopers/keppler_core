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

function copyHtml(id) {
  // Crea un campo de texto "oculto"
  var aux = document.createElement("textarea");
  // Asigna el contenido del elemento especificado al valor del campo
  aux.setAttribute("value", $("#"+id)[0].attributes.value.value);
  console.log(aux)
  // Añade el campo a la página
  document.body.appendChild(aux);
  // Selecciona el contenido del campo
  aux.select();
  // Copia el texto seleccionado
  document.execCommand("copy");
  // Elimina el campo de la página
  document.body.removeChild(aux);
}
