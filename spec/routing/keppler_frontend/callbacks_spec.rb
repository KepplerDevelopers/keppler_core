require 'rails_helper'

RSpec.describe 'routing to callback_functions', type: :routing do
  before(:each) do
    @callback = create(:keppler_frontend_callback_functions)
  end

  it 'routes GET /admin/frontend/callback_functions/' do
    expect(get: "/admin/frontend/callback_functions/").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'index'
    )
  end

  it 'routes GET /admin/frontend/callback_functions/new' do
    expect(get: "/admin/frontend/callback_functions/new").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'new'
    )
  end

  it 'routes POST /admin/frontend/callback_functions/create' do
    expect(post: "/admin/frontend/callback_functions").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'create'
    ) 
  end

  it 'routes GET /admin/frontend/callback_functions/:id/edit' do
    expect(get: "/admin/frontend/callback_functions/#{@callback.id}/edit").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'edit',
      id: @callback.id.to_s
    )
  end

  it 'routes PATCH /admin/frontend/callback_functions/:id' do
    expect(patch: "/admin/frontend/callback_functions/#{@callback.id}").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'update',
      id: @callback.id.to_s
    ) 
  end

  it 'routes GET /admin/frontend/callback_functions/:id/editor' do
    expect(get: "/admin/frontend/callback_functions/#{@callback.id}/editor").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'editor',
      callback_function_id: @callback.id.to_s
    )
  end

  it 'routes POST /admin/frontend/callback_functions/:id/editor/save' do
    expect(post: "/admin/frontend/callback_functions/#{@callback.id}/editor/save").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'editor_save',
      callback_function_id: @callback.id.to_s
    )
  end

  it 'routes DELETE /admin/frontend/callback_functions/:id' do
    expect(delete: "/admin/frontend/callback_functions/#{@callback.id}").to route_to(
      controller: 'keppler_frontend/admin/callback_functions',
      action: 'destroy',
      id: @callback.id.to_s
    )
  end
end
