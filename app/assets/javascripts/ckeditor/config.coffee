CKEDITOR.editorConfig = (config) ->
	config.toolbar_short = [['Styles', 'Format', 'Font', 'FontSize', 'TextColor', 'BGColor', 'Bold', 'Italic', 'Underline', 'Strike', '-', 'Subscript', 'Superscript', 'RemoveFormat', 'Preview', 'Undo', 'Redo', 'SelectAll', 'NumberedList', 'BulletedList', 'Link', 'Unlink', 'Anchor', 'Outdent', 'Indent', 'Blockquote', 'CreateDiv', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', 'BidiLtr', 'BidiRtl', 'Maximize']]

	config.toolbar_blog = [
		{
			name: 'riga1'
			items: [
				'Source'
				'Preview'
				'-'
				'Undo'
				'Redo'
			]
		}
		{
			name: 'riga2'
			items: [
				'Styles'
				'Format'
				'Font'
				'FontSize'
			]
		}
		{
			name: 'riga3'
			items: [
				'JustifyLeft'
				'JustifyCenter'
				'JustifyRight'
				'JustifyBlock'
				'-'
				'Bold'
				'Italic'
				'Underline'
				'-'
				'TextColor'
				'BGColor'
				'-'
				'NumberedList'
				'BulletedList'
				'-'
				'Image'
			]
		}       
	]
	return