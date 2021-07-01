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
end
