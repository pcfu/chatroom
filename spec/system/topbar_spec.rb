require 'rails_helper'

RSpec.describe "Topbar", type: :system, js: true do
  let(:user) { create :user }
  before { gui_login_user user }

  context "when extra small screen" do
    before { resize_window_to_xs }

    it "has icons only" do
      logo_width = page.evaluate_script("$('.navbar-brand img').width()")
      expect(logo_width).to eq(30)

      expect(page).to have_css('.sidebar-toggler .icon', count: 2)
      expect(page).to have_no_css('.sidebar-toggler .label')

      expect(page).to have_css('.gravatar')
      expect(page).to have_no_css('.navbar-username')
    end
  end

  context "when small screen and above" do
    before { resize_window_to_small }

    it "has icons and labels" do
      logo_width = page.evaluate_script("$('.navbar-brand img').width()")
      expect(logo_width).to eq(132)

      expect(page).to have_css('.sidebar-toggler .icon', count: 2)
      expect(page).to have_css('.sidebar-toggler .label', count: 2)

      expect(page).to have_css('.gravatar')
      expect(page).to have_css('.navbar-username')
    end
  end

  describe "on clicking channels" do
    context "when channels bar is expanded" do
      it "collapses the channels bar" do
        expect(page).to have_css('.channels-bar')
        find('.channels-toggler').click
        expect(page).to have_no_css('.channels-bar')
      end
    end

    context "when channels bar is collapsed" do
      it "expands the channels bar" do
      end
    end
  end

  describe "on clicking members" do
  end
end
