require 'rails_helper'

RSpec.describe 'routing to settings', type: :routing do

  it 'routes GET /admin/settings/configuration to admin/settings#edit' do
    expect(get: '/admin/settings/configuration').to route_to(
      controller: 'admin/settings',
      action: 'edit',
      config: 'configuration'
    )
  end
end
