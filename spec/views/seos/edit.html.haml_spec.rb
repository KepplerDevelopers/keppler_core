require 'rails_helper'

RSpec.describe "seos/edit", type: :view do
  before(:each) do
    @seo = assign(:seo, Seo.create!(
      :position => 1
    ))
  end

  it "renders the edit seo form" do
    render

    assert_select "form[action=?][method=?]", seo_path(@seo), "post" do

      assert_select "input[name=?]", "seo[position]"
    end
  end
end
