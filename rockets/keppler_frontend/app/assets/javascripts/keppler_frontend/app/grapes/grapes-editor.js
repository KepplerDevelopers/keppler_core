var extrasEditor = {
  buildHtml: function(html) {
    var sections = ""
    var sectionsPermit = ['keppler-header', 'keppler-view', 'keppler-footer']
    for(var i=0; i < html.length; i++) {
      if(sectionsPermit.includes(html[i].localName)) {
        var noEditIds = this.getNoEditIdsEditor(html[i]);
        for(var j=0; j < noEditIds.length; j++) {
          $(html[i]).find('#'+noEditIds[j]).replaceWith(function () {
            return $('<keppler-no-edit/>', {
                id: noEditIds[j],
                html: this.innerHTML
            });
          });
        }
        sections = sections+processHtml(html[i].outerHTML)
      }
    }
    return sections
  },

  getNoEditIdsEditor : function(section) {
    var nodes = section.querySelectorAll(".no-edit-area");
    var noEditIds = [];
    for(var i=0; i < nodes.length; i++) {
      noEditIds.push(nodes[i].id)
    }
    return noEditIds
  },

  getNoEditIds: function(){
    var nodes = document.querySelectorAll(".no-edit-area");
    var noEditIds = [];
    for(var i=0; i < nodes.length; i++) {
      noEditIds.push(nodes[i].id)
    }
    return noEditIds
  },

  createNoEditAreaEditor: function(){
    $('keppler-no-edit').addClass('no-edit-area');
    noEditIds = this.getNoEditIds();
    var $kepplerNoEdit = $("keppler-no-edit");
    $kepplerNoEdit.replaceWith(function () {
        return $('<div/>', {
            class: 'no-edit-area',
            html: this.innerHTML
        });
    });
    var nodes = document.querySelectorAll(".no-edit-area");
    for(var i=0; i < nodes.length; i++) {
      nodes[i].id = noEditIds[i];
    }
  },

  getIfNotArea: function(some) {
    var sections = ["keppler-header", "keppler-view", "keppler-footer"]
    var includeKepplerLabel = false;
    for(var i=0; i < some.path.length; i++) {
      var label = $(some.path[i])[0].id;
      if(sections.includes(label)) {
        includeKepplerLabel = true
      }
    }
    return includeKepplerLabel;
  },

  createAreas: function() {
    var sections = ['keppler-header', 'keppler-view', 'keppler-footer']

    for(var i=0; i < sections.length; i++) {
      $(sections[i]).replaceWith(function () {
          return $('<div/>', {
              id:  sections[i], 
              html: this.innerHTML
          });
      });
    }
  },

  deleteAreas: function(html, view_name) {
    var html = $(html);
    var sections = ['keppler-header', 'keppler-view', 'keppler-footer']
    var result = [];
    for(var i=0; i < html.length; i++) {
      if(sections.includes(html[i].id)) {
        var el = document.createElement(html[i].id)
        el.innerHTML = html[i].innerHTML
        if (html[i].id==="keppler-view") {
          el.id = view_name;
        }
        result.push(el)
      }
    }
    return result;
  },

}


$(document).ready(function(){
//grapesjs.plugins.add('testplug', (editor, config) => {});
var blkStyle = '.blk-row::after{ content: ""; clear: both; display: block;} .blk-row{padding: 10px;}';
var sectors = [{
  name: 'General',
  open: false,
  buildProps: ['float', 'display', 'z-index', 'position', 'top', 'right', 'left', 'bottom'],
  properties: [{
    id: 'z-index',
    type: 'integer',
    name: 'Position index',
    property: 'z-index',
    defaults: 0
  },{
    type: 'select',
    property: 'list-style-type',
    default: 'none',
    list    : [
      {value: 'none', name: 'None'},
      {value: 'circle', name: 'Circle'},
      {value: 'disc', name: 'Disc'},
      {value: 'square', name: 'Square'},
      {value: 'decimal', name: 'Decimal'},
      {value: 'decimal-leading-zero ', name: 'Decimal leading zero '},
      {value: 'lower-alpha', name: 'Lower alpha'},
      {value: 'upper-alpha', name: 'Upper alpha'},
      {value: 'lower-greek', name: 'Lower greek'},
      {value: 'lower-latin', name: 'Lower latin'},
      {value: 'upper-latin', name: 'Upper latin'},
      {value: 'lower-roman', name: 'Lower roman'},
      {value: 'upper-roman', name: 'Upper roman'},
      {value: 'armenian', name: 'Armenian'},
      {value: 'georgian', name: 'Georgian'},
      {value: 'cjk-ideographic', name: 'Cjk ideographic'},
      {value: 'hiragana', name: 'Hiragana'},
      {value: 'katakana', name: 'Katakana'},
      {value: 'hiragana-iroha', name: 'Hiragana iroha'},
      {value: 'katakana-iroha', name: 'Katakana iroha'},
    ],
  }, {
    property: 'list-style-position',
    type: 'radio',
    list    : [
      {value: 'inside', name: 'Inside'},
      {value: 'outside', name: 'Outside'}
    ],
  }, {
    property: 'cursor',
    type: 'select',
    defaults: 'auto',
    list    : [
      {value: 'auto', name: 'Auto'},
      {value: 'crosshair', name: 'Crosshair'},
      {value: 'default', name: 'Default'},
      {value: 'help', name: 'Help'},
      {value: 'move', name: 'Move'},
      {value: 'progress', name: 'Progress'},
      {value: 'pointer', name: 'Pointer'},
      {value: 'n-resize', name: 'N-resize'},
      {value: 'ne-resize ', name: 'Ne-resize '},
      {value: 'e-resize', name: 'E-resize'},
      {value: 'se-resize', name: 'Se-resize'},
      {value: 's-resize', name: 'S-resize'},
      {value: 'sw-resize', name: 'Sw-resize'},
      {value: 'w-resize', name: 'W-resize'},
      {value: 'nw-resize', name: 'Nw-resize'},
      {value: 'text', name: 'Text'},
      {value: 'wait', name: 'Wait'},
    ],
  }, {
    property: 'overflow',
    type: 'select',
    defaults: 'auto',
    list    : [
      {value: 'auto', name: 'Auto'},
      {value: 'hidden', name: 'Hidden'},
      {value: 'visible', name: 'Visible'},
      {value: 'scroll', name: 'Scroll'},
      {value: 'initial', name: 'Initial'},
      {value: 'inherit', name: 'Inherit'},
      
    ],
  }, {
    property: 'overflow-x',
    type: 'select',
    defaults: 'auto',
    list    : [
      {value: 'auto', name: 'Auto'},
      {value: 'hidden', name: 'Hidden'},
      {value: 'visible', name: 'Visible'},
      {value: 'scroll', name: 'Scroll'},
      {value: 'initial', name: 'Initial'},
      {value: 'inherit', name: 'Inherit'},
      
    ],
  }, {
    property: 'overflow-y',
    type: 'select',
    defaults: 'auto',
    list    : [
      {value: 'auto', name: 'Auto'},
      {value: 'hidden', name: 'Hidden'},
      {value: 'visible', name: 'Visible'},
      {value: 'scroll', name: 'Scroll'},
      {value: 'initial', name: 'Initial'},
      {value: 'inherit', name: 'Inherit'},
      
    ],
  }]
},{
  name: 'Dimension',
  open: false,
  buildProps: [ 'width', 'flex-width', 'height', 'min-width', 'max-width', 'min-height', 'max-height',
                'padding','margin'],
  properties: [{
    id: 'flex-width',
    type: 'integer',
    name: 'Width',
    units: ['px', '%', 'rem', 'em'],
    property: 'flex-basis',
    toRequire: 1,
  }, 
  {
    id: 'width',
    type: 'integer',
    name: 'Width',
    units: ['px', '%', 'rem', 'em'],
    property: 'width'
  },
  {
    id: 'height',
    type: 'integer',
    name: 'Height',
    units: ['px', '%', 'rem', 'em'],
    property: 'height'
  },
  {
    id: 'min-width',
    type: 'integer',
    name: 'Min width',
    units: ['px', '%', 'rem', 'em'],
    property: 'min-width'
  },
  {
    id: 'max-width',
    type: 'integer',
    name: 'Max width',
    units: ['px', '%', 'rem', 'em'],
    property: 'max-width'
  },
  {
    id: 'min-height',
    type: 'integer',
    name: 'Min height',
    units: ['px', '%', 'rem', 'em'],
    property: 'min-height'
  },
  {
    id: 'max-height',
    type: 'integer',
    name: 'Max height',
    units: ['px', '%', 'rem', 'em'],
    property: 'max-height'
  },
  {
    name    : 'Padding',
    property  : 'padding',
    type    : 'composite',
    properties  : [
      {
        id: 'padding-top',
        type: 'integer',
        name: 'Top',
        units: ['px', '%', 'rem', 'em'],
        property: 'padding-top',
        defaults: 0
      },
      {
        id: 'padding-right',
        type: 'integer',
        name: 'Right',
        units: ['px', '%', 'rem', 'em'],
        property: 'padding-right',
        defaults: 0
      },
      {
        id: 'padding-left',
        type: 'integer',
        name: 'Left',
        units: ['px', '%', 'rem', 'em'],
        property: 'padding-left',
        defaults: 0
      },
      {
        id: 'padding-bottom',
        type: 'integer',
        name: 'Bottom',
        units: ['px', '%', 'rem', 'em'],
        property: 'padding-bottom',
        defaults: 0
      }
    ]
  },   
  {
    name    : 'Margin',
    property  : 'margin',
    type    : 'composite',
    properties  : [
      {
        id: 'margin-top',
        type: 'integer',
        name: 'Top',
        units: ['px', '%', 'rem', 'em'],
        property: 'margin-top',
        defaults: 0
      },
      {
        id: 'margin-right',
        type: 'integer',
        name: 'Right',
        units: ['px', '%', 'rem', 'em'],
        property: 'margin-right',
        defaults: 0
      },
      {
        id: 'margin-left',
        type: 'integer',
        name: 'Left',
        units: ['px', '%', 'rem', 'em'],
        property: 'margin-left',
        defaults: 0
      },
      {
        id: 'margin-bottom',
        type: 'integer',
        name: 'Bottom',
        units: ['px', '%', 'rem', 'em'],
        property: 'margin-bottom',
        defaults: 0
      }
    ]
  }, 
  
]
},{
  name: 'Typography',
  open: false,
  buildProps: ['font-family', 'font-size', 'font-weight', 'letter-spacing', 'color', 'line-height', 
                'text-indent', 'font-style', 'text-align', 'text-transform', 'text-decoration', 'text-shadow'],
  properties: [{
    property: 'text-align',
    list    : [
      {value: 'left', className: 'fa fa-align-left'},
      {value: 'center', className: 'fa fa-align-center' },
      {value: 'right', className: 'fa fa-align-right'},
      {value: 'justify', className: 'fa fa-align-justify'}
    ],
  },
  {
    id: 'text-indent',
    type: 'integer',
    name: 'Text indent',
    units: ['px', '%', 'rem', 'em'],
    property: 'text-indent',
    defaults: 0
  },
  {
    property: 'font-style',
    type: 'radio',
    list    : [
      {value: 'normal', name: 'Normal'},
      {value: 'italic', name: 'Italic'},
      {value: 'oblique', name: 'Oblique'},
    ],
  },
  {
    property: 'text-transform',
    type: 'radio',
    list    : [
      {value: 'lowercase', name: 'a'},
      {value: 'uppercase', name: 'A'},
      {value: 'capitalize', name: 'Aa'}
    ],
  },
  {
    property: 'text-decoration',
    type: 'radio',
    list    : [
      {value: 'underline', className: 'fa fa-underline'},
      {value: 'line-through', className: 'fa fa-strikethrough'}
    ],
  },
  {
    property: 'font-family',
    type: 'text',
    // list    : [
    //   { name: 'Arial', value: 'Arial, Helvetica, sans-serif' },

    // ],
  }
]
},
{
  name: 'Background',
  open: false,
  buildProps: ['background-color', 'box-shadow', 'background'],
},{
  name: 'Border',
  open: false,
  buildProps: ['border-radius-c', 'border-radius', 'border'],
  properties: [
    {
      name    : 'Border width',
      property  : 'border-width',
      type    : 'composite',
      properties  : [
        {
          id: 'border-top-width',
          type: 'integer',
          name: 'Border top',
          units: ['px', '%', 'rem', 'em'],
          property: 'border-top-width',
          defaults: 0
        }, 
        {
          id: 'border-right-width',
          type: 'integer',
          name: 'Border right',
          units: ['px', '%', 'rem', 'em'],
          property: 'border-right-width',
          defaults: 0
        },
        {
          id: 'border-bottom-width',
          type: 'integer',
          name: 'Border bottom',
          units: ['px', '%', 'rem', 'em'],
          property: 'border-bottom-width',
          defaults: 0
        },
        {
          id: 'border-left-width',
          type: 'integer',
          name: 'Border left',
          units: ['px', '%', 'rem', 'em'],
          property: 'border-left-width',
          defaults: 0
        }
      ]
    }, 
  ]
},{
  name: 'Extra',
  open: false,
  buildProps: ['opacity', 'filter', 'transition', 'perspective', 'transform'],
  properties: [{
    type: 'slider',
    property: 'opacity',
    defaults: 1,
    step: 0.01,
    max: 1,
    min:0,
  }]
},{
    name: 'Flex',
    open: false,
    properties: [{
      name    : 'Flex Container',
      property  : 'display',
      type    : 'select',
      defaults  : 'block',
      list    : [{
                value     : 'block',
                name   : 'Disable',
              },{
                value   : 'flex',
                name   : 'Enable',
              }],
    },{
      name: 'Flex Parent',
      property: 'label-parent-flex',
    },{
      name      : 'Direction',
      property  : 'flex-direction',
      type    : 'radio',
      defaults  : 'row',
      list    : [{
                value   : 'row',
                name    : 'Row',
                className : 'icons-flex icon-dir-row',
                title   : 'Row',
              },{
                value   : 'row-reverse',
                name    : 'Row reverse',
                className : 'icons-flex icon-dir-row-rev',
                title   : 'Row reverse',
              },{
                value   : 'column',
                name    : 'Column',
                title   : 'Column',
                className : 'icons-flex icon-dir-col',
              },{
                value   : 'column-reverse',
                name    : 'Column reverse',
                title   : 'Column reverse',
                className : 'icons-flex icon-dir-col-rev',
              }],
    },{
      name      : 'Wrap',
      property  : 'flex-wrap',
      type    : 'radio',
      defaults  : 'nowrap',
      list    : [{
                value   : 'nowrap',
                title   : 'Single line',
              },{
                value   : 'wrap',
                title   : 'Multiple lines',
              },{
                value   : 'wrap-reverse',
                title   : 'Multiple lines reverse',
              }],
    },{
      name      : 'Justify',
      property  : 'justify-content',
      type    : 'radio',
      defaults  : 'flex-start',
      list    : [{
                value   : 'flex-start',
                className : 'icons-flex icon-just-start',
                title   : 'Start',
              },{
                value   : 'flex-end',
                title    : 'End',
                className : 'icons-flex icon-just-end',
              },{
                value   : 'space-between',
                title    : 'Space between',
                className : 'icons-flex icon-just-sp-bet',
              },{
                value   : 'space-around',
                title    : 'Space around',
                className : 'icons-flex icon-just-sp-ar',
              },{
                value   : 'center',
                title    : 'Center',
                className : 'icons-flex icon-just-sp-cent',
              }],
    },{
      name      : 'Align',
      property  : 'align-items',
      type    : 'radio',
      defaults  : 'center',
      list    : [{
                value   : 'flex-start',
                title    : 'Start',
                className : 'icons-flex icon-al-start',
              },{
                value   : 'flex-end',
                title    : 'End',
                className : 'icons-flex icon-al-end',
              },{
                value   : 'stretch',
                title    : 'Stretch',
                className : 'icons-flex icon-al-str',
              },{
                value   : 'center',
                title    : 'Center',
                className : 'icons-flex icon-al-center',
              }],
    },{
      name: 'Flex Children',
      property: 'label-parent-flex',
    },{
      name:     'Order',
      property:   'order',
      type:     'integer',
      defaults :  0,
      min: 0
    },{
      name    : 'Flex',
      property  : 'flex',
      type    : 'composite',
      properties  : [{
              name:     'Grow',
              property:   'flex-grow',
              type:     'integer',
              defaults :  0,
              min: 0
            },{
              name:     'Shrink',
              property:   'flex-shrink',
              type:     'integer',
              defaults :  0,
              min: 0
            },{
              name:     'Basis',
              property:   'flex-basis',
              type:     'integer',
              units:    ['px','%',''],
              unit: '',
              defaults :  'auto',
            }],
    },{
      name      : 'Align',
      property  : 'align-self',
      type      : 'radio',
      defaults  : 'auto',
      list    : [{
                value   : 'auto',
                name    : 'Auto',
              },{
                value   : 'flex-start',
                title    : 'Start',
                label: 'Start',
                className : 'icons-flex icon-al-start',
              },{
                value   : 'flex-end',
                title    : 'End',
                className : 'icons-flex icon-al-end',
              },{
                value   : 'stretch',
                title    : 'Stretch',
                className : 'icons-flex icon-al-str',
              },{
                value   : 'center',
                title    : 'Center',
                className : 'icons-flex icon-al-center',
              }],
    }]
  }

];


var links = document.getElementsByTagName('link')
var styles = [];
for(var i=1; i < links.length; i++) {
  styles.push(links[i].href)
}

var links = document.getElementsByTagName('script')
var scripts = [];
for(var i=0; i < links.length; i++) {
  scripts.push(links[i].src)
}

try {
  var css_style = gon.css_style;
  var images_assets = gon.images_assets;
  var view_id = gon.view_id;
  var view_name = gon.view_name;
} catch (e) {
  if (e instanceof SyntaxError) {
      console.log(e.message);
  }
}  

var editor  = grapesjs.init(
{
  container: '#keppler-editor',
  protectedCss: '',
  style: css_style,
  scripts: "function abr(){}",
  canvas: {
    styles: styles, 
    scripts: scripts
  },
  width: 'auto',
  fromElement: true,
  //
  plugins: ['testplug', 'gjs-blocks-basic', 'grapesjs-custom-code', 'gjs-plugin-forms', 'grapesjs-lory-slider', 'gjs-component-countdown', 'gjs-style-gradient'],
  pluginsOpts: {
    'gjs-style-gradient': {
      colorPicker: 'default',
      grapickOpts: {
        min: 1,
        max: 99,
      }
    }
  },
  autorender: 0,
  allowScripts: 1,
  showOffsets: 1,
  noticeOnUnload: 0,
  avoidInlineStyle: 1,
  avoidDefaults: 1,
  // forceClass: 0,
  storageManager: { autoload: 0 },
  // storageManager: { type: 'firebase-firestore' },
  layerManager: {
    showWrapper: 0,
  },
  assetManager: {
    upload: '/admin/frontend/assets/upload',
    autoAdd: true,
    assets: images_assets
  },

  styleManager : {
    clearProperties: 1,
    sectors: sectors,
  },

});


window.editor = editor;

function saveCode() { 
  try {
    var html = extrasEditor.deleteAreas(editor.getHtml(), view_name);
    var html = extrasEditor.buildHtml(html);
    var css = editor.getCss();
    var css = cssbeautify(css, {
      indent: ' ',
      openbrace: 'separate-line',
      autosemicolon: true
      });    
    
    $.post("/admin/frontend/views/"+view_id+"/live_editor/save", {html: html, css: css}, function(data){
      alert(data.result)
    }) 
  } catch (e) {
    alert("Error when saving: Check that all is well")
  }   
}


var toogleTools = false;
var pnm = editor.Panels;

pnm.addButton('commands', [
  {
    id: 'keppler-logo',
    className: 'gjs-keppler-logo',
    command: function(e) {},
  }
]);

pnm.addButton('options', [{
  id: 'undo',
  className: 'fa fa-undo icon-undo',
  title: 'Undo',
  command: function(e) { return e.runCommand('core:undo') },
},{
  id: 'redo',
  title: 'Redo',
  className: 'fa fa-repeat icon-redo',
  command: function(e) { return e.runCommand('core:redo') },
}, 
{
  id: 'refresh',
  title: 'Refresh',
  className: 'fa fa-refresh',
  command(editor, sender) {
    window.location.reload();
  },
},
// {
//   id: 'clear-all',
//   className: 'fa fa-trash icon-blank',
//   command: function(e) { return e.runCommand('core:canvas-clear') },
// }, 
{
  id: 'save-code',
  title: 'Save',
  className: 'fa fa-save',
  command(editor, sender) {
    saveCode(editor, view_id); 
  },
}, {
  id: 'exit',
  title: 'Exit',
  className: 'fa fa-sign-out',
  command(editor, sender) {
    var confirmation = confirm("Are you sure?");
    if (confirmation===true) {
      var route = "/admin/frontend/views/"+view_id+"/editor";
      window.location.href = route
    }     
  },
},
{
  id: 'show-tools',
  title: 'Open tools',
  className: 'fa fa-bars',
  command(editor, sender) {  
    if(toogleTools===false)  {
      $(".gjs-pn-views").removeClass('gsj-hide-tools').addClass('gsj-show-tools')
      $(".gjs-pn-views-container").removeClass('gsj-hide-tools').addClass('gsj-show-tools')
      $(".gjs-pn-options > .gjs-pn-buttons > .gjs-pn-btn.fa-bars ").removeClass('fa-bars').addClass('fa-times')
      toogleTools=true
    } else {
      $(".gjs-pn-views").removeClass('gsj-show-tools').addClass('gsj-hide-tools')
      $(".gjs-pn-views-container").removeClass('gsj-show-tools').addClass('gsj-hide-tools')
      $(".gjs-pn-options > .gjs-pn-buttons > .gjs-pn-btn.fa-times ").removeClass('fa-times').addClass('fa-bars')
      toogleTools=false
    }
  },
}]);


editor.StyleManager.addProperty('Background', {
  id: 'gradient',
  name: 'Gradient',
  property: 'background-image',
  type: 'gradient',
  defaults: 'none'
});

var codeButton = pnm.getButton("options", "fullscreen");
codeButton.collection.remove(codeButton);
// var codeButton = editor.Panels.getButton("options", "export-template");
// codeButton.collection.remove(codeButton);

var bm = editor.BlockManager;
var noArea = false;



editor.on('canvas:dragenter', (some, argument) => {
  // do something
  $(".gjs-pn-views").removeClass('gsj-show-tools').addClass('gsj-hide-tools')
  $(".gjs-pn-views-container").removeClass('gsj-show-tools').addClass('gsj-hide-tools')
  $(".gjs-pn-options > .gjs-pn-buttons > .gjs-pn-btn.fa-bars ").removeClass('fa-times').addClass('fa-bars')
})

editor.on('canvas:dragend', (some, argument) => {
  // do something
  noArea = extrasEditor.getIfNotArea(some);
 
  $(".gjs-pn-views").removeClass('gsj-hide-tools').addClass('gsj-show-tools')
  $(".gjs-pn-views-container").removeClass('gsj-hide-tools').addClass('gsj-show-tools')
  $(".gjs-pn-options > .gjs-pn-buttons > .gjs-pn-btn.fa-times ").removeClass('fa-bars').addClass('fa-times')
})

editor.on("block:drag:start", (some, argument) => {
  var section = ['header', 'view', 'footer']

  for(var i=0; i < section.length; i++) {
    var el = $(".gjs-frame").contents().find("#keppler-"+section[i]);
    $(el).addClass("keppler-"+section[i]+"-area")
  }
})


editor.on("block:drag:stop", (some, argument) => {
  var section = ['header', 'view', 'footer']

  for(var i=0; i < section.length; i++) {
    var el = $(".gjs-frame").contents().find("#keppler-"+section[i]);
    $(el).removeClass("keppler-"+section[i]+"-area")
  }
  var el = $(some.view.$el[0]);
  if (!noArea) {
    el.remove();
  }
})


bm.add('link', {
  label: 'Link',
  category: 'Basic',
  attributes: {class:'fa fa-link'},
  content: {
    type:'link',
    content:'Link',
    style:{color: '#d983a6'}
  }
});

bm.add('link-block', {
  label: 'Link Block',
  attributes: {class:'fa fa-link'},
  category: 'Basic',
  content: {
    type:'link',
    editable: false,
    draggable: '#wrapper',
    style:{
      display: 'inline-block',
      padding: '5px',
      'min-height': '50px',
      'min-width': '50px'
    }
  },
});

bm.add('image', {
  label: 'Image',
  category: 'Basic',
  attributes: {class:'gjs-fonts gjs-f-image'},
  content: {
    style: {color: 'black'},
    type:'image',
    activeOnRender: 1
  }
});

bm.add('video', {
  label: 'Video',
  category: 'Basic',
  attributes: {class:'fa fa-youtube-play'},
  content: {
    type: 'video',
    src: 'img/video2.webm',
    style: {
      height: '350px',
      width: '615px',
    }
  }
});

bm.add('b1-2', {
  label: 'Flex Columns',
  category: 'Layouts',
  attributes: { class:'gjs-fonts gjs-f-b1' },
  content: `
    <div class="row-flex" data-columns="1" style="text-align: center" data-gjs-droppable="[data-column]" data-gjs-highlightable="false" data-gjs-resizable='{"tl":0,"tc":0,"tr":0,"cl":0,"cr":0,"bl":0,"br":0}' data-gjs-custom-name="Row">
      <div class="cell-flex" data-column="1" style="letter-spacing: normal; flex-basis: 100%" data-gjs-draggable="[data-columns]" data-gjs-resizable='{"tl":0,"tc":0,"tr":0,"cl":0,"bl":0,"br":0,"bc": 0, "keyWidth": "flex-basis", "currentUnit": 1, "minDim": 1, "maxDim": 100, "step": 0.2}' data-gjs-unstylable='["width"]' data-gjs-stylable-require='["flex-basis"]'></div>
      <div class="cell-flex" data-column="1" style="letter-spacing: normal; flex-basis: 100%" data-gjs-draggable="[data-columns]" data-gjs-resizable='{"tl":0,"tc":0,"tr":0,"cl":0,"bl":0,"br":0,"bc": 0, "keyWidth": "flex-basis", "currentUnit": 1, "minDim": 1, "maxDim": 100, "step": 0.2}' data-gjs-unstylable='["width"]' data-gjs-stylable-require='["flex-basis"]'></div>
    </div>
    <style>
      .row-flex {
          display: flex;
          justify-content: flex-start;
          align-items: stretch;
          flex-wrap: nowrap;
          padding: 10px;
      }

      .cell-flex {
        min-height: 75px;
        flex-grow: 1;
        flex-basis: 100%;
      }
    </style>
    `
});

try {
  for(var i=0; i < gon.components.length; i++) {    
    var component = eval(gon.components[i][0]);     
    if (component.length === 2) {
      component[1].content.components = gon.components[i][1]
      bm.add(component[0], component[1]);
    }      
  }
} catch (e) {
  if (e instanceof SyntaxError) {
      console.log(e.message);
  }
} 

bm.add('section', {
  id: 'section',
  label: 'Section',
  attributes: {class:'fa fa-code'},
  category: 'Layouts',
  content: {
    content:'<section>Section content</section>',
    style: {padding: '10px' },
    activeOnRender: 1
  }
});

bm.add('text', {
  id: 'text',
  label: 'Text',
  attributes: {class:'gjs-fonts gjs-f-text'},
  category: 'Typography',
  content: {
    type:'text',
    content:'Insert your text here',
    style: {padding: '10px' },
    activeOnRender: 1
  }, 
});

bm.add('h1p', {
  label: 'Text section',
  category: 'Typography',
  content: `<div>
    <h1 class="heading">Insert title here</h1>
    <p class="paragraph">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua</p>
    </div>`,
  attributes: {class:'gjs-fonts gjs-f-h1p'}  
});

bm.add('quo', {
  label: 'Quote',
  category: 'Typography',
  content: '<blockquote class="quote">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore ipsum dolor sit</blockquote>',
  attributes: {class:'fa fa-quote-right'} 
});

bm.add('map', {
  label: 'Map',
  category: 'Extra',
  attributes: {class:'fa fa-map-o'},
  content: {
    type: 'map',
    style: {height: '350px'}
  },
});

// Store and load events
editor.on('storage:load', function(e) {
  // console.log('LOAD ', e);
});
editor.on('storage:store', function(e) {
  // console.log('STORE ', e);
});

var domComps = editor.DomComponents;
var dType = domComps.getType('default');
var dModel = dType.model;
var dView = dType.view;

domComps.addType('input', {
    model: dModel.extend({
      defaults: Object.assign({}, dModel.prototype.defaults, {
        traits: [
          // strings are automatically converted to text types
          'name',
          'placeholder',
          {
            type: 'select',
            label: 'Type',
            name: 'type',
            options: [
              {value: 'text', name: 'Text'},
              {value: 'email', name: 'Email'},
              {value: 'password', name: 'Password'},
              {value: 'number', name: 'Number'},
            ]
          }, {
            type: 'checkbox',
            label: 'Required',
            name: 'required',
        }],
      }),
    }, {
      isComponent: function(el) {
        if(el.tagName == 'INPUT'){
          return {type: 'input'};
        }
      },
    }),

    view: dView,
});


editor.on('traverse:html', function (node, resultNode) {

});
editor.on('load', () => {
});
editor.render();

editor.on('styleable:change', (model, property) => {
  const value = model.getStyle()[property];
  if (value!=undefined && value.indexOf('!important') === -1) {
    // if (property.includes("background")) {
    model.addStyle({ [property]: value + ' !important' });
    // }
  }
});

// Commands
editor.Commands.add('set-device-desktop', {
  run: editor => editor.setDevice('Desktop')
});
editor.Commands.add('set-device-mobile', {
  run: editor => editor.setDevice('Mobile')
});

var devices = editor.DeviceManager;

devices.add('Desktop Extra Large (1900px)', '1900px');

devices.add('Desktop Large (1600px)', '1600px');

devices.add('Desktop Medium (1440px)', '1440px');

devices.add('iPad Portrait (768px)', '768px');

devices.add('iPad Landscape (1024px x 768px)', '1024px', {
  height: '768px'
});

devices.add('Galaxy S5 Portrait (360px x 640px)', '360px', {
  height: '640px'
});

devices.add('Galaxy S5 Landscape (640px x 360px)', '640px', {
  height: '360px'
});

devices.add('Pixel 2 Portrait (411px x 731px)', '411px', {
  height: '731px'
});

devices.add('Pixel 2 Landscape (731px x 411px)', '731px', {
  height: '411px'
});

devices.add('Pixel 2 XL Portrait (411px x 823px)', '411px', {
  height: '823px'
});

devices.add('Pixel 2 XL Landscape (823px x 411px)', '823px', {
  height: '411px'
});

devices.add('iPhone 5/SE Portrait (320px x 568px)', '320px', {
  height: '568px'
});

devices.add('iPhone 5/SE Landscape (568px x 320px)', '568px', {
  height: '320px'
});

devices.add('iPhone 6/7/8 Portrait (375px x 667px)', '375px', {
  height: '667px'
});

devices.add('iPhone 6/7/8 Landscape (667px x 375px)', '667px', {
  height: '375px'
});

devices.add('iPhone 6/7/8 Plus Portrait (414px x 736px)', '414px', {
  height: '736px'
});

devices.add('iPhone 6/7/8 Plus Landscape (736px x 414px)', '736px', {
  height: '414px'
});

devices.add('iPhone X Portrait (375px x 812px)', '375px');

devices.add('iPhone X Landscape (812px x 375px)', '812px', {
  height: '375px'
});

})



extrasEditor.createNoEditAreaEditor();
extrasEditor.createAreas();

// Quitar el keppler-style link de layers
$(document).ready(function(){
  $('.gjs-pn-buttons > .gjs-pn-btn').click(function() {
    var layers = $('.gjs-layer');
    if(layers.length > 0) {
      for(var i=0; i < layers.length; i++) {
        // console.log(layers[i])
        if(layers[i].outerText==="Keppler-style\n1") {
          $(layers[i]).remove();
        }
      }
    }
  });
})
