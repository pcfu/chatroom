require 'rails_helper'

RSpec.describe "Navbar", type: :system, js: true do
  context "when collapsed" do
    before do
      resize_window_to_small
      visit '/'
    end
    after { resize_window_to_default }

    it "expands navbar on menu click" do
      find('button.navbar-toggler').click
      expect(page).to have_css('a.navbar-brand[href="/"]')
      expect(page).to have_link('About', href: '#')
      expect(page).to have_link('Features', href: '#')
      expect(page).to have_link('Sample Link', href: '#')
      expect(page).to have_link('Login', href: '/login')
      expect(page).to have_css('button.close')
    end

    it "collapses navbar on close click", js: true do
      find('button.navbar-toggler').click
      find('button.close').click
      expect(page).to have_no_link('About', href: '#')
      expect(page).to have_no_link('Features', href: '#')
      expect(page).to have_no_link('Sample Link', href: '#')
      expect(page).to have_no_link('Login', href: '/login')
      expect(page).to have_no_css('button.close')
    end
  end
end
