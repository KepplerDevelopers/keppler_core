var editor = '';

var controls = {
  codes: {},
  save: function(id) {
    this.codes = {
      ruby: editor.getValue()
    }
    $.post("/admin/seo/editor/save", this.codes, function(data){
      $("#code-sitemap").val(editor.getValue())
      $('.sitemap_signal').css('display', 'none');
    })
  }
}

var codeSitemap = {
  codeMirrorSitemap: function(code) {
    $("#code-sitemap").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor.on('change', function () {
        if(editor.getValue() === $("#code-sitemap").val()) {
          $('.sitemap_signal').css('display', 'none');
        } else {
          $('.sitemap_signal').css('display', 'block');
        }
      });
    });
    return editor;
  },
  save: function() {
    if(editor.getValue() !== $("#code-sitemap").val()) {
      this.codes = {
        sitemap: editor.getValue()
      }
      $.post("/admin/seo/editor/save", this.codes, function(data){
        $("#code-sitemap").val(editor.getValue())
        $('.sitemap_signal').css('display', 'none');
      })
    }
  },
}
