require 'rails_helper'
require 'support/shared_examples_for_pages'

RSpec.describe "UserRegistrations", type: :system do
  describe "page is displayed correctly" do
    before { visit register_path }

    it_behaves_like 'static page'

    it "has correct title" do
      expect(page).to have_title('Chatroom | Registration', exact: true)
    end

    it "has correct form elements" do
      within('form') do
        expect(page).to have_css('div.form-header', text: 'Create an account')
        has_field_with_label 'user_username', 'username'
        has_field_with_label 'user_email', 'email'

        expect(page).to have_css 'label[for=user_dob]',  text: icase_exact('date of birth')
        expect(page).to have_css '.styleable-select-prompt',  text: icase_exact('day')
        expect(page).to have_css '.styleable-select-prompt',  text: icase_exact('month')
        expect(page).to have_css '.styleable-select-prompt',  text: icase_exact('year')

        has_field_with_label 'user_password', 'password'
        has_field_with_label 'user_password_confirmation', 'confirm password'
        expect(page).to have_button('register')
        expect(page).to have_link('Already have an account?', href: 'login')
      end
    end
  end

  context "user creates a new account" do
    before { visit '/register' }
  end
end
