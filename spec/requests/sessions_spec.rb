require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    context "when logged out" do
      it "returns http success" do
        get '/login'
        expect(response).to have_http_status(:success)
      end
    end

    context "when logged in" do
      it "returns redirect" do
        login_user
        get '/login'
        expect(response).to be_redirect
      end
    end
  end

  describe "POST /login" do
    context "when valid login" do
      it "returns http success" do
        login_user
        expect(controller.logged_in?).to be true
        expect(response).to have_http_status(:success)
      end
    end

    context "when invalid login" do
      it "returns http unauthorized" do
        params = { session: attributes_for(:user).extract!(:username, :password) }
        post '/login', params: params
        expect(controller.logged_in?).to be false
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /logout" do
    it "returns redirect" do
      login_user
      delete '/logout'
      expect(controller.logged_in?).to be false
      expect(response).to be_redirect
    end
  end
end
