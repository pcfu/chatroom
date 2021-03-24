RSpec.shared_examples_for 'static page' do
  context "when medium screen and above" do
    before { resize_window_to_medium }
    after { resize_window_to_default }

    it "has an expanded navbar", js: true do
      expect(page).to have_css('body > nav', count: 1)
      expect(page).to have_css('body > div', count: 1)
      expect(page).to have_css('body > nav:nth-child(1).navbar')
      expect(page).to have_css('body > div:nth-child(2).container')

      within('nav > div.container') do
        expect(page).to have_css('a.navbar-brand[href="/"]')
        expect(page).to have_link('About', href: '#')
        expect(page).to have_link('Features', href: '#')
        expect(page).to have_link('Sample Link', href: '#')
        expect(page).to have_link('Login', href: '#')

        expect(page).to have_no_css('button.navbar-toggler')
      end
    end
  end

  context "when small screen and below" do
    before { resize_window_to_small }
    after { resize_window_to_default }

    it "has a collapsed navbar", js: true do
      expect(page).to have_css('body > nav', count: 1)
      expect(page).to have_css('body > div', count: 1)
      expect(page).to have_css('body > nav:nth-child(1).navbar')
      expect(page).to have_css('body > div:nth-child(2).container')

      within('nav > div.container') do
        expect(page).to have_css('a.navbar-brand[href="/"]')
        expect(page).to have_css('button.navbar-toggler')

        expect(page).to have_no_link('About', href: '#')
        expect(page).to have_no_link('Features', href: '#')
        expect(page).to have_no_link('Sample Link', href: '#')
        expect(page).to have_no_link('Login', href: '#')
      end
    end

    it "expands navbar on menu click", js: true do
      find('button.navbar-toggler').click
      expect(page).to have_css('a.navbar-brand[href="/"]')
      expect(page).to have_link('About', href: '#')
      expect(page).to have_link('Features', href: '#')
      expect(page).to have_link('Sample Link', href: '#')
      expect(page).to have_link('Login', href: '#')
      expect(page).to have_css('button.close')
    end

    it "collapses navbar on close click", js: true do
      find('button.navbar-toggler').click
      find('button.close').click
      expect(page).to have_no_link('About', href: '#')
      expect(page).to have_no_link('Features', href: '#')
      expect(page).to have_no_link('Sample Link', href: '#')
      expect(page).to have_no_link('Login', href: '#')
      expect(page).to have_no_css('button.close')
    end
  end
end
