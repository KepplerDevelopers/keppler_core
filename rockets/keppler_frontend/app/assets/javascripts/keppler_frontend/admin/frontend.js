var editor = '';
var codeMaster = {
  save: function(id) {
    $.post("/admin/frontend/views/"+id+"/editor/save", {html: editor.getValue()}, function(data){
      $('.html_signal').css('display', 'none');
    })
  },
  formatHtml: function(code) {
    var i = 0;
    for(i; i < code.length; i++) {
      code = code.replace("&#39;", '"');
      code = code.replace("&lt;", "<");
      code = code.replace("&gt;", ">");
      code = code.replace("&quot;", "'");
    }
    return code;
  },
  codeMirrorHtml: function() {
    $("#code-html").each(function() {
      editor =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/html",
        theme: 'monokai',
        indentUnit: 2,
        smartIndent: true,
        tabSize: 2,
        keyMap: 'sublime'
      });
    });
    return editor;
  }
}
