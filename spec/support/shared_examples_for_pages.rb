RSpec.shared_examples_for 'static page' do
  context "when medium screen and above" do
    before { resize_window_to_medium }
    after { resize_window_to_default }

    it "has an expanded navbar", js: true do
      expect(page).to have_css('#navbar-collapsible')
    end
  end

  context "when small screen and below" do
    before { resize_window_to_small }
    after { resize_window_to_default }

    it "has a collapsed navbar", js: true do
      expect(page).to have_no_css('#navbar-collapsible')
    end
  end
end
