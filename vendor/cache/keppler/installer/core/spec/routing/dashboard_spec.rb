require 'rails_helper'

RSpec.describe 'routing to dashboard', type: :routing do

  it 'routes GET /admin to dashboard#analytics' do
    expect(get: '/admin').to route_to(
      controller: 'admin/admin',
      action: 'root'
    )
  end
end
