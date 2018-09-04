require 'rails_helper'

RSpec.describe "seos/show", type: :view do
  before(:each) do
    @seo = assign(:seo, Seo.create!(
      :position => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
  end
end
