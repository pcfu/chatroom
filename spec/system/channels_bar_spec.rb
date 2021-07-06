require 'rails_helper'

RSpec.describe "ChannelsBar", type: :system, js: true do
  let(:user) { create :user }
  before { gui_login_user user }

  context "when expanded" do
    before { page.evaluate_script("$('.channels-bar').removeClass('collapsed')") }

    it "has a collapse toggler" do
      expect(page).to have_css('.channels-bar .bar-toggler > .collapse-icon')
    end

    it "has no expand toggler" do
      expect(page).to have_no_css('.channels-bar .bar-toggler > .expand-icon')
    end

    it "collapses on toggler click" do
      find('.bar-toggler').click
      expect(page).to have_css('.channels-bar.collapsed')
    end
  end

  context "when collapsed" do
    before { page.evaluate_script("$('.channels-bar').addClass('collapsed')") }

    context "when extra small screen" do
      before { resize_window_to_xs }

      it "has zero width" do
        expect_elem_width('.channels-bar', 0)
      end

      it "has no toggler buttons" do
        expect(page).to have_no_css('.channels-bar .bar-toggler')
        expect(page).to have_no_css('.channels-bar .bar-toggler > .collapse-icon')
        expect(page).to have_no_css('.channels-bar .bar-toggler > .expand-icon')
      end
    end

    context "when small screen and above" do
      before { resize_window_to_small }

      it "has minimal width" do
        expect_elem_width('.channels-bar', 15)
      end

      it "has an expand toggler" do
        expect(page).to have_css('.channels-bar .bar-toggler > .expand-icon')
      end

      it "has no collapse toggler" do
        expect(page).to have_no_css('.channels-bar .bar-toggler > .collapse-icon')
      end
    end

    it "expands on toggler click" do
      find('.bar-toggler').click
      expect(page).to have_no_css('.channels-bar.collapsed')
    end
  end
end
