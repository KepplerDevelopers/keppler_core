var editor_head = '';
var editor_header = '';
var editor_footer = '';

var controlsLayout = {
  codes: {},
  save: function(id) {
    this.codes = {
      head: editor_head.getValue(),
      header: editor_header.getValue(),
      footer: editor_footer.getValue()
    }
    $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
      $("#code-head").val(editor.getValue())
      $("#code-header").val(editor_header.getValue())
      $("#code-footer").val(editor_footer.getValue())
      $('.head_signal').css('display', 'none');
      $('.header_signal').css('display', 'none');
      $('.footer_signal').css('display', 'none');
    })
  }
}

var codeHead = {
  codeMirrorHead: function(code) {
    $("#code-head").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_head = CodeMirror.fromTextArea($(this).get(0), {
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

      editor_head.on('change', function () {
        if(editor_head.getValue() === $("#code-head").val()) {
          $('.head_signal').css('display', 'none');
        } else {
          $('.head_signal').css('display', 'block');
        }
      });
    });
    return editor_head
  },
  saveHead: function(id) {
    if(editor_head.getValue() !== $("#code-head").val()) {
      this.codes = {
        head: editor_head.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-head").val(editor_head.getValue())
        $('.head_signal').css('display', 'none');
      })
    }
  }
}

var codeHeader = {
  codeMirrorHeader: function() {
    $("#code-header").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_header =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
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

      editor_header.on('change', function () {
        if(editor_header.getValue() === $("#code-header").val()) {
          $('.header_signal').css('display', 'none');
        } else {
          $('.header_signal').css('display', 'block');
        }
      });
    });
    return editor_header;
  },
  saveHeader: function(id) {
    if(editor_header.getValue() !== $("#code-header").val()) {
      this.codes = {
        header: editor_header.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-header").val(editor_header.getValue())
        $('.header_signal').css('display', 'none');
      })
    }
  }
}

var codeFooter = {
  codeMirrorFooter: function() {
    $("#code-footer").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_footer =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
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

      editor_footer.on('change', function () {
        if(editor_footer.getValue() === $("#code-footer").val()) {
          $('.footer_signal').css('display', 'none');
        } else {
          $('.footer_signal').css('display', 'block');
        }
      });
    });
    return editor_footer;
  },
  saveFooter: function(id) {
    if(editor_footer.getValue() !== $("#code-footer").val()) {
      this.codes = {
        footer: editor_footer.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-footer").val(editor_footer.getValue())
        $('.footer_signal').css('display', 'none');
      })
    }
  }
}
