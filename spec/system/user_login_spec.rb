require 'rails_helper'
require 'support/shared_examples_for_pages'

RSpec.describe "UserLogins", type: :system do
  describe "page is displayed correctly" do
    before { visit '/login' }

    it_behaves_like 'static page'

    it "has correct title" do
      expect(page).to have_title('Chatroom | Login', exact: true)
    end

    it "has correct form elements", js: true do
      within 'form' do
        expect(page).to have_css('div.form-header', text: 'Welcome back')
        has_field_with_label('session_username', 'username')
        has_field_with_label('session_password', 'password')

        expect(page).to have_link('Forgot password?', href: '#')
        expect(page).to have_button('login')
        expect(page).to have_css('small.form-text', text: 'New to Chatroom?')
        expect(page).to have_link('Register now!', href: '/register')
      end
    end

    it "clears field errors on key up", js: true do
        find(".btn[value=login]").click
        %w(username password).each do |field|
          page.evaluate_script "$('#session_#{field}').trigger('keyup')"
          expect(page).to have_no_css("label[for='session_#{field}'] span.message")
        end
    end
  end

  describe "user logins with account", js: true do
    let(:user) { create(:user) }

    before do
      visit '/login'
    end

    context "when valid info" do
      it "logs in and redirects to another page" do
        fill_in 'session_username', with: user.username
        fill_in 'session_password', with: user.password
        find(".btn[value=login]").click
        expect(page).to have_current_path('/chatroom')
      end
    end

    context "when invalid info" do
      it "displays error messages and does not redirect" do
        page_should_not_reload do
          fill_in 'session_username', with: 'dummy_user'
          fill_in 'session_password', with: user.password
          find(".btn[value=login]").click
          expect(page).to have_css("label[for='session_username'] span.message", text: "not recognized")

          fill_in 'session_username', with: user.username
          fill_in 'session_password', with: 'dummy_password'
          find(".btn[value=login]").click
          expect(page).to have_css("label[for='session_password'] span.message", text: "incorrect password")
        end
      end
    end

    context "when empty inputs" do
      it "displays message to enter info" do
        find(".btn[value=login]").click
        expect(page).to have_css("label[for='session_username'] span.message", text: "please enter username")
        expect(page).to have_css("label[for='session_password'] span.message", text: "please enter password")

        fill_in 'session_username', with: user.username
        find(".btn[value=login]").click
        expect(page).to have_no_css("label[for='session_username'] span.message")

        find('#session_username').native.clear
        fill_in "session_password", with: user.password
        expect(page).to have_no_css("label[for='session_password'] span.message")
      end
    end
  end
end
