var editor = '';
var editor_robots = '';

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
  },
  saveTxt: function(id) {
    this.codes = {
      txt: editor_robots.getValue()
    }
    $.post("/admin/seo/editor/save", this.codes, function(data){
      $("#code-robots").val(editor_robots.getValue())
      $('.robots_signal').css('display', 'none');
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
  }
}

var codeRobots = {
  codeMirrorRobots: function(code) {
    $("#code-robots").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_robots =  CodeMirror.fromTextArea($(this).get(0), {
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

      editor_robots.on('change', function () {
        if(editor_robots.getValue() === $("#code-robots").val()) {
          $('.robots_signal').css('display', 'none');
        } else {
          $('.robots_signal').css('display', 'block');
        }
      });
    });
    return editor_robots;
  }
}
