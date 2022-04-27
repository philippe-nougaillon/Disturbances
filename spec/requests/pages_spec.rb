require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /status" do
    it "returns http success" do
      get "/pages/status"
      expect(response).to have_http_status(:success)
    end
  end

end
