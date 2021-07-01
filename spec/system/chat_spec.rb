require 'rails_helper'

RSpec.describe "Chats", type: :system do
  let(:user) { create(:user) }

  describe "page is displayed correctly", js: true do
    before { gui_login_user user }

    it "has a topbar" do
      expect(page).to have_css('nav.topbar')
    end

    context "when extra small screen" do
      before { resize_window_to_xs }

      it "has collapsed sidebars" do
        expect(page).to have_no_css('.channels-bar')
        expect(page).to have_no_css('.users-bar')
      end
    end

    context "when small screen and below" do
      before { resize_window_to_small }

      it "has expanded channels bar and collapsed users bar" do
        expect(page).to have_css('.channels-bar')
        expect(page).to have_no_css('.users-bar')
      end
    end

    context "when medium screen and above" do
      before { resize_window_to_medium }

      it "has expanded sidebars" do
        expect(page).to have_css('.channels-bar')
        expect(page).to have_css('.users-bar')
      end
    end
  end
end
