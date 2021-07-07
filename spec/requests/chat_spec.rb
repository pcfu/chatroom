require 'rails_helper'

RSpec.describe "Chat", type: :request do
  describe "GET /chat" do
    context "when logged out" do
      it "returns redirect" do
        get '/chat'
        expect(response).to be_redirect
      end
    end

    context "when logged in" do
      it "return http success" do
        login_user
        get '/chat'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
