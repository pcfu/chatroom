require 'rails_helper'

RSpec.describe "Topbar", type: :system, js: true do
  let(:user) { create :user }
  before { gui_login_user user }

  context "when extra small screen" do
    before { resize_window_to_xs }

    it "has icons only" do
      expect_elem_width('.navbar-brand img', 30)

      expect(page).to have_css('.sidebar-toggler .icon', count: 2)
      expect(page).to have_no_css('.sidebar-toggler .label')

      expect(page).to have_css('.gravatar')
      expect(page).to have_no_css('.navbar-username')
    end
  end

  context "when small screen and above" do
    before { resize_window_to_small }

    it "has icons and labels" do
      expect_elem_width('.navbar-brand img', 132)

      expect(page).to have_css('.sidebar-toggler .icon', count: 2)
      expect(page).to have_css('.sidebar-toggler .label', count: 2)

      expect(page).to have_css('.gravatar')
      expect(page).to have_css('.navbar-username')
    end
  end

  describe "on clicking channels" do
    context "when channels bar is expanded" do
      before { page.evaluate_script("$('.channels-bar').removeClass('collapsed')") }

      it "collapses the channels bar" do
        expect(page).to have_no_css('.channels-bar.collapsed')
        find('.channels-toggler').click
        expect(page).to have_css('.channels-bar.collapsed')
      end
    end

    context "when channels bar is collapsed" do
      before { page.evaluate_script("$('.channels-bar').addClass('collapsed')") }

      it "expands the channels bar" do
        expect(page).to have_css('.channels-bar.collapsed')
        find('.channels-toggler').click
        expect(page).to have_no_css('.channels-bar.collapsed')
      end
    end

    context "when extra small screen with collapsed channels bar and expanded members bar" do
      before do
        resize_window_to_xs
        page.evaluate_script("$('.channels-bar').addClass('collapsed')")
        page.evaluate_script("$('.members-bar').removeClass('collapsed')")
      end

      it "collapses the members bar and expands the channels bar" do
        expect(page).to have_css('.channels-bar.collapsed')
        expect(page).to have_no_css('.members-bar.collapsed')
        find('.channels-toggler').click
        expect(page).to have_css('.members-bar.collapsed')
        expect(page).to have_no_css('.channels-bar.collapsed')
      end
    end
  end

  describe "on clicking members" do
    context "when members bar is expanded" do
      before { page.evaluate_script("$('.members-bar').removeClass('collapsed')") }

      it "collapses the members bar" do
        expect(page).to have_no_css('.members-bar.collapsed')
        find('.members-toggler').click
        expect(page).to have_css('.members-bar.collapsed')
      end
    end

    context "when members bar is collapsed" do
      before { page.evaluate_script("$('.members-bar').addClass('collapsed')") }

      it "expands the members bar" do
        expect(page).to have_css('.members-bar.collapsed')
        find('.members-toggler').click
        expect(page).to have_no_css('.members-bar.collapsed')
      end
    end

    context "when extra small screen with collapsed members bar and expanded channels bar" do
      before do
        resize_window_to_xs
        page.evaluate_script("$('.members-bar').addClass('collapsed')")
        page.evaluate_script("$('.channels-bar').removeClass('collapsed')")
      end

      it "collapses the channels bar and expands the members bar" do
        expect(page).to have_css('.members-bar.collapsed')
        expect(page).to have_no_css('.channels-bar.collapsed')
        find('.members-toggler').click
        expect(page).to have_css('.channels-bar.collapsed')
        expect(page).to have_no_css('.members-bar.collapsed')
      end
    end
  end
end
