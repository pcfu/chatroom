require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /register" do
    context "when logged out" do
      it "returns http success" do
        get '/register'
        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in" do
      it "returns redirect" do
        login_user
        get '/register'
        expect(response).to be_redirect
      end
    end
  end
end
