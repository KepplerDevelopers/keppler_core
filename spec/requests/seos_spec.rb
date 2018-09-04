require 'rails_helper'

RSpec.describe "Seos", type: :request do
  describe "GET /seos" do
    it "works! (now write some real specs)" do
      get seos_path
      expect(response).to have_http_status(200)
    end
  end
end
