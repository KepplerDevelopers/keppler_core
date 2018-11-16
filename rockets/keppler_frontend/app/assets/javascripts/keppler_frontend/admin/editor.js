var editor = '';
var editor_css = '';
var editor_js = '';
var editor_js_erb = '';
var editor_action = '';
var editor_callback = '';
var editor_function = '';

var controls = {
  codes: {},
  save: function(id) {
    this.codes = {
      html: editor.getValue(),
      scss: editor_css.getValue(),
      js: editor_js.getValue(),
      ruby: editor_action.getValue()
    }
    $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
      $("#code-html").val(editor.getValue())
      $("#code-css").val(editor_css.getValue())
      $("#code-js").val(editor_js.getValue())
      $("#code-action").val(editor_action.getValue())
      $('.html_signal').css('display', 'none');
      $('.scss_signal').css('display', 'none');
      $('.js_signal').css('display', 'none');
      $('.action_signal').css('display', 'none');
    })
  },
  saveLayout: function(id){
    this.codes = {
      html: editor.getValue()
    }
    $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
      $("#code-html").val(editor.getValue())
      $('.html_signal').css('display', 'none');
    })
  },
  saveOnlyAction: function(){
    this.codes = {
      ruby: editor.getValue()
    }
    $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
      $("#code-action").val(editor_action.getValue())
      $('.action_signal').css('display', 'none');
    })
  },
  saveViewJs: function(){
    this.codes = {
      ruby: editor_action.getValue(),
      js_erb: editor_js_erb.getValue(),
    }
    $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
      $("#code-action").val(editor_action.getValue())
      $("#code-js-erb").val(editor_js_erb.getValue())
      $('.action_signal').css('display', 'none');
      $('.js_erb_signal').css('display', 'none');
    })
  }
}

var codeHTML = {
  codeMirrorHtml: function(code) {
    $("#code-html").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor =  CodeMirror.fromTextArea($(this).get(0), {
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
        showToken: /\w/,
        scrollbarStyle: "overlay",
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
    return editor;
  },
  save: function(id) {
    if(editor.getValue() !== $("#code-html").val()) {
      this.codes = {
        html: editor.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-html").val(editor.getValue())
        $('.html_signal').css('display', 'none');
      })
    }
  },

  saveLayout: function(id){
    if(editor.getValue() !== $("#code-html").val()) {
      this.codes = {
        html: editor.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-html").val(editor.getValue())
        $('.html_signal').css('display', 'none');
      })
    }
  },
}

var codeCSS = {
  codeMirrorCSS: function() {
    $("#code-css").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_css =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-scss",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        showTrailingSpace: true,
        tabSize: 2,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_css.on('change', function () {
        if(editor_css.getValue() === $("#code-css").val()) {
          $('.scss_signal').css('display', 'none');
        } else {
          $('.scss_signal').css('display', 'block');
        }
      });
    });
    return editor_css;
  },
  save: function(id) {
    if(editor_css.getValue() !== $("#code-css").val()) {
      this.codes = {
        scss: editor_css.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-css").val(editor_css.getValue())
        $('.scss_signal').css('display', 'none');
      })
    }
  }
}

var codeJs = {
  codeMirrorJs: function() {
    $("#code-js").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_js =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/javascript",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_js.on('change', function () {
        if(editor_js.getValue() === $("#code-js").val()) {
          $('.js_signal').css('display', 'none');
        } else {
          $('.js_signal').css('display', 'block');
        }
      });
    });
    return editor_js;
  },
  save: function(id) {
    if(editor_js.getValue() !== $("#code-js").val()) {
      this.codes = {
        js: editor_js.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-js").val(editor_js.getValue())
        $('.js_signal').css('display', 'none');
      })
    }
  }
}

var codeJsErb = {
  codeMirrorJsErb: function() {
    $("#code-js-erb").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_js_erb =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/javascript",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_js_erb.on('change', function () {
        if(editor_js_erb.getValue() === $("#code-js").val()) {
          $('.js_erb_signal').css('display', 'none');
        } else {
          $('.js_erb_signal').css('display', 'block');
        }
      });
    });
    return editor_js;
  },
  save: function(id) {
    if(editor_js_erb.getValue() !== $("#code-js-erb").val()) {
      this.codes = {
        js_erb: editor_js_erb.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-js-erb").val(editor_js_erb.getValue())
        $('.js_erb_signal').css('display', 'none');
      })
    }
  }
}

var codeAction = {
  codeMirrorAction: function() {
    $("#code-action").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_action =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_action.on('change', function () {
        if(editor_action.getValue() === $("#code-action").val()) {
          $('.action_signal').css('display', 'none');
        } else {
          $('.action_signal').css('display', 'block');
        }
      });
    });
    return editor_action;
  },
  save: function(id) {
    if(editor_action.getValue() !== $("#code-action").val()) {
      this.codes = {
        ruby: editor_action.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-action").val(editor_action.getValue())
        $('.action_signal').css('display', 'none');
      })
    }
  }
}

var codeCallback = {
  codeMirrorCallback: function() {
    $("#code-callback").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_callback =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        scrollbarStyle: "overlay",
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

      editor_callback.on('change', function () {
        if(editor_callback.getValue() === $("#code-action").val()) {
          $('.callback_signal').css('display', 'none');
        } else {
          $('.callback_signal').css('display', 'block');
        }
      });
    });
    return editor_callback;
  },
  save: function(id) {
    if(editor_callback.getValue() !== $("#code-callback").val()) {
      this.codes = {
        ruby: editor_callback.getValue()
      }
      $.post("/admin/frontend/callback_functions/"+id+"/editor/save", this.codes, function(data){
        $("#code-callback").val(editor_callback.getValue())
        $('.callback_signal').css('display', 'none');
      })
    }
  }
}

var codeFunction = {
  codeMirrorFunction: function() {
    $("#code-function").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_function =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        scrollbarStyle: "overlay",
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_function.on('change', function () {
        if(editor_function.getValue() === $("#code-function").val()) {
          $('.function_signal').css('display', 'none');
        } else {
          $('.function_signal').css('display', 'block');
        }
      });
    });
    return editor_function;
  },
  save: function(id) {
    if(editor_function.getValue() !== $("#code-function").val()) {
      this.codes = {
        ruby: editor_function.getValue()
      }
      $.post("/admin/frontend/functions/"+id+"/editor/save", this.codes, function(data){
        $("#code-function").val(editor_callback.getValue())
        $('.function_signal').css('display', 'none');
      })
    }
  }
}
