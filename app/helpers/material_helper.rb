# MaterialHelper
module MaterialHelper
  def preloader
    content_tag :div, class: 'preloader-wrapper big active' do
      concat spinner_layer('blue')
      concat spinner_layer('red')
      concat spinner_layer('yellow')
      concat spinner_layer('green')
    end
  end

  private

  def spinner_layer(_color)
    content_tag :div, class: 'spinner-layer spinner-#{color}' do
      clipper('left') + gap_path + clipper('right')
    end
  end

  def clipper(direction)
    content_tag(
      :div,
      content_tag(:div, nil, class: 'circle'),
      class: "circle-clipper #{direction}"
    )
  end

  def gap_path
    content_tag(
      :div,
      content_tag(:div, nil, class: 'circle'),
      class: 'gap-path'
    )
  end
end
