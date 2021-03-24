require 'rails_helper'

RSpec.describe "Statics", type: :request do
  describe "GET /root" do
    it "responds successfully" do
      get root_path
      expect(response).to have_http_status '200'
    end
  end

  describe "GET /register" do
    it "responds successfully" do
      get register_path
      expect(response).to have_http_status '200'
    end
  end
end
