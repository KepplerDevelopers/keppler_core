require 'rails_helper'

RSpec.describe 'routing to functions', type: :routing do
  before(:each) do
    @function = create(:keppler_frontend_functions)
  end

  it 'routes GET /admin/frontend/functions/' do
    expect(get: "/admin/frontend/functions/").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'index'
    )
  end

  it 'routes GET /admin/frontend/functions/new' do
    expect(get: "/admin/frontend/functions/new").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'new'
    )
  end

  it 'routes POST /admin/frontend/functions/create' do
    expect(post: "/admin/frontend/functions").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'create'
    ) 
  end

  it 'routes GET /admin/frontend/functions/:id/edit' do
    expect(get: "/admin/frontend/functions/#{@function.id}/edit").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'edit',
      id: @function.id.to_s
    )
  end

  it 'routes PATCH /admin/frontend/functions/:id' do
    expect(patch: "/admin/frontend/functions/#{@function.id}").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'update',
      id: @function.id.to_s
    ) 
  end

  it 'routes GET /admin/frontend/functions/:id' do
    expect(get: "/admin/frontend/functions/#{@function.id}").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'show',
      id: @function.id.to_s
    )
  end

  it 'routes POST /admin/frontend/functions/:id/editor/save' do
    expect(post: "/admin/frontend/functions/#{@function.id}/editor/save").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'editor_save',
      function_id: @function.id.to_s
    )
  end

  it 'routes DELETE /admin/frontend/functions/:id' do
    expect(delete: "/admin/frontend/functions/#{@function.id}").to route_to(
      controller: 'keppler_frontend/admin/functions',
      action: 'destroy',
      id: @function.id.to_s
    )
  end
end
