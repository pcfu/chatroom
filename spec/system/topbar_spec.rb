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

    context "when channels bar is collapsed and members bar is expanded" do
      before do
        page.evaluate_script("$('.channels-bar').addClass('collapsed')")
        page.evaluate_script("$('.members-bar').removeClass('collapsed')")
      end

      it "collapses the members bar and expands the channels bar on clicking channels" do
        expect(page).to have_no_css('.members-bar.collapsed')
        expect_elem_width('.channels-bar', 0)
        find('.channels-toggler').click
        expect_elem_width('.members-bar', 0)
        expect(page).to have_no_css('.channels-bar.collapsed')
      end
    end

    context "when members bar is collapsed and channels bar is expanded" do
      before do
        page.evaluate_script("$('.members-bar').addClass('collapsed')")
        page.evaluate_script("$('.channels-bar').removeClass('collapsed')")
      end

      it "collapses the channels bar and expands the members bar on clicking members" do
        expect(page).to have_no_css('.channels-bar.collapsed')
        expect_elem_width('.members-bar', 0)
        find('.members-toggler').click
        expect_elem_width('.channels-bar', 0)
        expect(page).to have_no_css('.members-bar.collapsed')
      end
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
    end
  end
end
