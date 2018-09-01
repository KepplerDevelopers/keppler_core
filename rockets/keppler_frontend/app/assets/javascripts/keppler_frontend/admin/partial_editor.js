var editor = '';
var partial_editor_css = '';
var partial_editor_js = '';

var controlsPartial = {
  codes: {},
  savePartial: function(id) {
    this.codes = {
      html: editor.getValue(),
      scss: partial_editor_css.getValue(),
      js: partial_editor_js.getValue()
    }
    $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
      $("#code-html").val(editor.getValue())
      $("#code-css").val(partial_editor_css.getValue())
      $("#code-js").val(partial_editor_js.getValue())
      $('.html_signal').css('display', 'none');
      $('.scss_signal').css('display', 'none');
      $('.js_signal').css('display', 'none');
    })
  }
}

var codePartialHTML = {
  codeMirrorHtml: function(code) {
    $("#code-html").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor = CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
        keyMap: "sublime",
        autoCloseBrackets: true,
        matchBrackets: true,
        theme: "monokai",
        tabSize: 2,
        autoCloseTags: true,
        matchTags: {bothTags: true},
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {
          "Ctrl-Space": "autocomplete",
          "Ctrl-J": "toMatchingTag"
        }
      });

      editor.on('change', function () {
        if(editor.getValue() === $("#code-html").val()) {
          $('.html_signal').css('display', 'none');
        } else {
          $('.html_signal').css('display', 'block');
        }
      });
    });
    return editor
  },
  savePartial: function(id) {
    if(editor.getValue() !== $("#code-html").val()) {
      this.codes = {
        html: editor.getValue()
      }
      $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
        $("#code-html").val(editor.getValue())
        $('.html_signal').css('display', 'none');
      })
    }
  }
}

var codePartialCSS = {
  codeMirrorCSS: function() {
    $("#code-css").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      partial_editor_css = CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-scss",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        showTrailingSpace: true,
        tabSize: 2,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      partial_editor_css.on('change', function () {
        if(partial_editor_css.getValue() === $("#code-css").val()) {
          $('.scss_signal').css('display', 'none');
        } else {
          $('.scss_signal').css('display', 'block');
        }
      });
    });
    return partial_editor_css;
  },
  savePartial: function(id) {
    if(partial_editor_css.getValue() !== $("#code-css").val()) {
      this.codes = {
        scss: partial_editor_css.getValue()
      }
      $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
        $("#code-css").val(partial_editor_css.getValue())
        $('.scss_signal').css('display', 'none');
      })
    }
  }
}

var codePartialJs = {
  codeMirrorJs: function() {
    $("#code-js").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      partial_editor_js =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/javascript",
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

      partial_editor_js.on('change', function () {
        if(partial_editor_js.getValue() === $("#code-js").val()) {
          $('.js_signal').css('display', 'none');
        } else {
          $('.js_signal').css('display', 'block');
        }
      });
    });
    return partial_editor_js;
  },
  savePartial: function(id) {
    if(partial_editor_js.getValue() !== $("#code-js").val()) {
      this.codes = {
        js: partial_editor_js.getValue()
      }
      $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
        $("#code-js").val(partial_editor_js.getValue())
        $('.js_signal').css('display', 'none');
      })
    }
  }
}


function copyHtml(id) {
  const el = document.createElement('textarea');
  el.value = $("#"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}

function copyPartial(id) {
  const el = document.createElement('textarea');
  el.value = $("#partial"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}
