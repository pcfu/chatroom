require 'rails_helper'

RSpec.describe "Chats", type: :system do
  let(:user) { create(:user) }

  describe "page has correct layout", js: true do
    before { gui_login_user user }

    it "has a topbar" do
      expect(page).to have_css('nav.topbar')
    end

    describe "on page load" do
      context "when small screen and below" do
        before do
          resize_window_to_small
          reload_page
        end

        it "has collapsed sidebars" do
          expect(page).to have_css('.channels-bar.collapsed')
          expect(page).to have_css('.members-bar.collapsed')
        end
      end

      context "when medium screen and above" do
        before do
          resize_window_to_medium
          reload_page
        end

        it "has expanded sidebars" do
          expect(page).to have_no_css('.channels-bar.collapsed')
          expect(page).to have_css('.channels-bar')
          expect(page).to have_no_css('.members-bar.collapsed')
          expect(page).to have_css('.members-bar')
        end
      end
    end
  end
end
