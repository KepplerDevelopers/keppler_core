require 'rails_helper'

RSpec.describe 'routing to views', type: :routing do
  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
  end

  it 'routes POST /live_editor/save to keppler_frontend/admin/views#live_editor_save' do
    expect(post: "/admin/frontend/views/#{@view.id}/live_editor/save").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'live_editor_save',
      view_id: @view.id.to_s
    )
  end
end
