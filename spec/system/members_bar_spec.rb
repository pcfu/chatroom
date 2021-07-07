require 'rails_helper'

RSpec.describe "MembersBar", type: :system, js: true do
  let(:user) { create :user }
  before { gui_login_user user }

  context "when expanded" do
    before { page.evaluate_script("$('.members-bar').removeClass('collapsed')") }

    it "has a collapse toggler" do
      expect(page).to have_css('.members-bar .bar-toggler > .collapse-icon')
    end

    it "has no expand toggler" do
      expect(page).to have_no_css('.members-bar .bar-toggler > .expand-icon')
    end
  end

  context "when collapsed" do
    before { page.evaluate_script("$('.members-bar').addClass('collapsed')") }

    context "when extra small screen" do
      before { resize_window_to_xs }

      it "has zero width" do
        expect_elem_width('.members-bar', 0)
      end

      it "has no toggler buttons" do
        expect(page).to have_no_css('.members-bar .bar-toggler')
        expect(page).to have_no_css('.members-bar .bar-toggler > .collapse-icon')
        expect(page).to have_no_css('.members-bar .bar-toggler > .expand-icon')
      end
    end

    context "when small screen and above" do
      before { resize_window_to_small }

      it "has minimal width" do
        expect_elem_width('.members-bar', 15)
      end

      it "has an expand toggler" do
        expect(page).to have_css('.members-bar .bar-toggler > .expand-icon')
      end

      it "has no collapse toggler" do
        expect(page).to have_no_css('.members-bar .bar-toggler > .collapse-icon')
      end
    end
  end
end
