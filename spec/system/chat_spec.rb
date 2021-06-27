require 'rails_helper'

RSpec.describe "Chats", type: :system do
  let(:user) { create(:user) }

  describe "page is displayed correctly", js: true do
    before { gui_login_user user }

    it "has a topbar" do
      expect(page).to have_css('nav.topbar')
    end
  end
end
