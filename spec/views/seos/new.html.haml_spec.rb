require 'rails_helper'

RSpec.describe "seos/new", type: :view do
  before(:each) do
    assign(:seo, Seo.new(
      :position => 1
    ))
  end

  it "renders new seo form" do
    render

    assert_select "form[action=?][method=?]", seos_path, "post" do

      assert_select "input[name=?]", "seo[position]"
    end
  end
end
