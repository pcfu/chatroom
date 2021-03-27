require 'rails_helper'
require 'support/shared_examples_for_pages'

RSpec.describe "UserRegistrations", type: :system do
  describe "page is displayed correctly" do
    before { visit register_path }

    it_behaves_like 'static page'

    it "has correct title" do
      expect(page).to have_title('Chatroom | Registration', exact: true)
    end

    it "has correct form elements", js: true do
      within 'form' do
        expect(page).to have_css('div.form-header', text: 'Create an account')
        has_field_with_label('user_username', 'username')
        has_field_with_label('user_email', 'email')

        expect(page).to have_css('label[for=user_dob]',  text: icase_exact('date of birth'))
        expect(page).to have_css('.styleable-select-prompt',  text: icase_exact('day'))
        expect(page).to have_css('#user_dob_day .styleable-select-options', visible: false)
        expect(page).to have_css('.styleable-select-prompt',  text: icase_exact('month'))
        expect(page).to have_css('#user_dob_month .styleable-select-options', visible: false)
        expect(page).to have_css('.styleable-select-prompt',  text: icase_exact('year'))
        expect(page).to have_css('#user_dob_year .styleable-select-options', visible: false)

        has_field_with_label('user_password', 'password')
        has_field_with_label('user_password_confirmation', 'confirm password')
        expect(page).to have_button('register')
        expect(page).to have_link('Already have an account?', href: 'login')
      end
    end

    it "has expandable custom select elements", js: true do
      within 'form' do
        %i(day month year).each do |part|
          elem_id = "#user_dob_#{part}"

          find("#{elem_id} .styleable-select").click
          expect(page).to have_css("#{elem_id} .styleable-select-options")
          find("#{elem_id} .styleable-select").click
          expect(page).to have_no_css("#{elem_id} .styleable-select-options")

          find("#{elem_id} .styleable-select").click
          find('.form-header').click
          expect(page).to have_no_css("#{elem_id} .styleable-select-options")
        end
      end
    end
  end

  describe "user creates a new account", js: true do
    context "when valid user info" do
      it "creates account and redirects to another page" do
        user = build_stubbed(:user)

        visit register_path
        fill_in :user_username, with: user.username
        fill_in :user_email, with: user.email

        mth = Date::MONTHNAMES[user.dob.month]
        find_and_click_styleable_select_option('#user_dob_day', user.dob.day)
        find_and_click_styleable_select_option('#user_dob_month', mth)
        find_and_click_styleable_select_option('#user_dob_year', user.dob.year)

        fill_in :user_password, with: user.password
        fill_in :user_password_confirmation, with: user.password_confirmation

        expect {
          find(".btn[value=register]").click
        }.to change(User.all, :count).by(1)

        expect(current_path).to have_content(chatroom_path)
      end
    end

    context "when invalid user info" do
      it "does not create account and stays on same page" do
        user = build_stubbed(:user, :username_too_short)

        visit register_path
        fill_in :user_username, with: user.username
        fill_in :user_email, with: user.email

        mth = Date::MONTHNAMES[user.dob.month]
        find_and_click_styleable_select_option('#user_dob_day', user.dob.day)
        find_and_click_styleable_select_option('#user_dob_month', mth)
        find_and_click_styleable_select_option('#user_dob_year', user.dob.year)

        fill_in :user_password, with: user.password
        fill_in :user_password_confirmation, with: user.password_confirmation

        expect {
          find(".btn[value=register]").click
        }.to change(User.all, :count).by(0)

        expect(current_path).to have_content(register_path)
      end
    end
  end
end
