require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "returns http success" do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /login" do
    context "when valid login" do
      it "returns http success" do
        create(:user)
        attrs = attributes_for(:user)
        params = {
          session: {
            username: attrs[:username],
            password: attrs[:password]
          }
        }

        post '/login', params: params
        expect(response).to have_http_status(:success)
      end
    end

    context "when invalid login" do
      it "returns http unauthorized" do
        attrs = attributes_for(:user)
        params = {
          session: {
            username: attrs[:username],
            password: attrs[:password]
          }
        }

        post '/login', params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
