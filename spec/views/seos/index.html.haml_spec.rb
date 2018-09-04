require 'rails_helper'

RSpec.describe "seos/index", type: :view do
  before(:each) do
    assign(:seos, [
      Seo.create!(
        :position => 2
      ),
      Seo.create!(
        :position => 2
      )
    ])
  end

  it "renders a list of seos" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
