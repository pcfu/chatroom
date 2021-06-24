require 'rails_helper'

RSpec.describe "Navbar", type: :system, js: true do
  context "when collapsed" do
    before do
      resize_window_to_small
      visit '/'
    end
    after { resize_window_to_default }

    context "when menu closed" do
      it "has minimal menu links" do
        expect(page).to have_css('a.navbar-brand[href="/"]')
        expect(page).to have_css('button.navbar-toggler')
        expect_no_static_pages_links
      end

      it "opens menu on toggler click" do
        find('button.navbar-toggler').click
        expect(page).to have_css('#navbar-collapsible.show')
        expect(page).to have_css('a.navbar-brand[href="/"]')
        expect_static_pages_links
        expect(page).to have_css('button.close')
      end
    end

    context "when menu open" do
      before { find('button.navbar-toggler').click }

      it "closes menu on close click", js: true do
        find('button.close').click
        expect(page).to have_no_css('#navbar-collapsible.show')
        expect_no_static_pages_links
        expect(page).to have_no_css('button.close')
      end

      context "when logged out" do
        it "has full links with login button" do
          expect(page).to have_css('a.navbar-brand[href="/"]')
          expect(page).to have_css('button.close')
          expect_static_pages_links
          expect(page).to have_link('Login', href: '/login')
        end
      end

      context "when logged in" do
        let(:user) { create :user }
        before do
          gui_login_user user
          find('button.navbar-toggler').click
        end

        it "has full links with user controls" do
          expect(page).to have_css('a.navbar-brand[href="/"]')
          expect(page).to have_css('button.close')
          expect_static_pages_links

          expect(page).to have_css('img.gravatar')
          expect(page).to have_css('.navbar-username', text: user.username)
          expect(page).to have_link('Account', href: '#')
          expect(page).to have_link('Logout', href: '/logout')
        end
      end
    end
  end

  context "when expanded" do
    before do
      resize_window_to_medium
      visit '/'
    end

    it "has no menu toggler" do
      expect(page).to have_no_css('button.navbar-toggler')
    end

    context "when logged out" do
      it "has full links with login button" do
        expect(page).to have_css('a.navbar-brand[href="/"]')
        expect_static_pages_links
        expect(page).to have_link('Login', href: '/login')
      end
    end

    context "when logged in" do
      let(:user) { create :user }
      before { gui_login_user user }

      it "has full links with user profile" do
        expect(page).to have_css('a.navbar-brand[href="/"]')
        expect_static_pages_links
        expect(page).to have_css('img.gravatar')
        expect(page).to have_css('.navbar-username', text: user.username)
        expect(page).to have_no_link('Account', href: '#')
        expect(page).to have_no_link('Logout', href: '/logout')
      end

      context "when account panel closed" do
        it "opens account panel on clicking user profile" do
          find('.navbar-user-panel').click
          expect(page).to have_link('Account', href: '#')
          expect(page).to have_link('Logout', href: '/logout')
        end
      end

      context "when account panel open" do
        before { find('.navbar-user-panel').click }

        it "closes account panel on clicking user profile" do
          find('.navbar-user-panel').click
          expect(page).to have_no_link('Account', href: '#')
          expect(page).to have_no_link('Logout', href: '/logout')
        end

        it "closes account panel on clicking outside the panel" do
          click_at(5, 5, css: 'nav')
          expect(page).to have_no_link('Account', href: '#')
          expect(page).to have_no_link('Logout', href: '/logout')
        end
      end
    end
  end
end
