require 'rails_helper'

RSpec.describe 'routing to views', type: :routing do
  before(:each) do
    @view = create(:keppler_frontend_views, method: "GET")
  end

  it 'routes GET /admin/frontend/views/' do
    expect(get: "/admin/frontend/views/").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'index'
    )
  end

  it 'routes GET /admin/frontend/views/new' do
    expect(get: "/admin/frontend/views/new").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'new'
    )
  end

  it 'routes POST /admin/frontend/views/create' do
    expect(post: "/admin/frontend/views").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'create'
    ) 
  end

  it 'routes GET /admin/frontend/views/:id/edit' do
    expect(get: "/admin/frontend/views/#{@view.id}/edit").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'edit',
      id: @view.id.to_s
    )
  end

  it 'routes PATCH /admin/frontend/views/:id' do
    expect(patch: "/admin/frontend/views/#{@view.id}").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'update',
      id: @view.id.to_s
    ) 
  end

  it 'routes GET /admin/frontend/views/:id/editor' do
    expect(get: "/admin/frontend/views/#{@view.id}/editor").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'editor',
      view_id: @view.id.to_s
    )
  end

  it 'routes POST /admin/frontend/views/:id/editor/save' do
    expect(post: "/admin/frontend/views/#{@view.id}/editor/save").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'editor_save',
      view_id: @view.id.to_s
    )
  end

  it 'routes DELETE /admin/frontend/views/:id' do
    expect(delete: "/admin/frontend/views/#{@view.id}").to route_to(
      controller: 'keppler_frontend/admin/views',
      action: 'destroy',
      id: @view.id.to_s
    )
  end
end
