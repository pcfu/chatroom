require 'rails_helper'
require 'support/shared_examples_for_pages'

RSpec.describe "UserRegistrations", type: :system do
  describe "page is displayed correctly" do
    before { visit '/register' }

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
        expect(page).to have_link('Already have an account?', href: '/login')
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
    before { visit '/register' }

    context "when valid user info" do
      let(:user) { build_stubbed(:user) }
      before do
        fill_in :user_username, with: user.username
        fill_in :user_email, with: user.email

        mth = Date::MONTHNAMES[user.dob.month]
        find_and_click_styleable_select_option('#user_dob_day', user.dob.day)
        find_and_click_styleable_select_option('#user_dob_month', mth)
        find_and_click_styleable_select_option('#user_dob_year', user.dob.year)

        fill_in :user_password, with: user.password
        fill_in :user_password_confirmation, with: user.password_confirmation
      end

      it "creates account" do
        expect {
          find(".btn[value=register]").click
        }.to change(User.all, :count).by(1)
      end

      it "redirects to chat page" do
        find(".btn[value=register]").click
        expect(page).to have_current_path('/chat')
      end
    end

    context "when invalid user info" do
      it "has error messages beside field labels" do
        user = build_stubbed(:user, :username_too_short, :email_no_username, :pw_too_long)

        field = 'user_username'
        fill_in field, with: user.username
        find("label[for='#{field}']").click
        expect(page).to have_css("label[for='#{field}'] span.message", text: "is too short")

        field = 'user_email'
        fill_in field, with: user.email
        find("label[for='#{field}']").click
        expect(page).to have_css("label[for='#{field}'] span.message", text: "is invalid")

        field = 'user_password'
        fill_in field, with: user.password
        find("label[for='#{field}']").click
        expect(page).to have_css("label[for='#{field}'] span.message", text: "is too long")

        user = build_stubbed(:user, :pw_not_equal_confirmation)

        field = 'user_password_confirmation'
        fill_in :user_password, with: user.password
        fill_in field, with: user.password_confirmation
        find("label[for='#{field}']").click
        expect(page).to have_css("label[for='#{field}'] span.message", text: "doesn't match password")
      end

      it "does not create account and does not reload page" do
        user = build_stubbed(:user, :username_too_short)

        page_should_not_reload do
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
        end
      end
    end

    context "when unique fields are not unique" do
      it "reloads the page with pre-filled data" do
        user = create(:user)

        page_should_reload do
          fill_in :user_username, with: user.username
          fill_in :user_email, with: user.email

          mth = Date::MONTHNAMES[user.dob.month]
          find_and_click_styleable_select_option('#user_dob_day', user.dob.day)
          find_and_click_styleable_select_option('#user_dob_month', mth)
          find_and_click_styleable_select_option('#user_dob_year', user.dob.year)

          fill_in :user_password, with: user.password
          fill_in :user_password_confirmation, with: user.password_confirmation
          find(".btn[value=register]").click
        end

        expect(page).to have_field('user_username', with: user.username)
        expect(page).to have_field('user_email', with: user.email)

        expect(page).to have_css('#user_dob_day .styleable-select-prompt', text: user.dob.day)
        day = page.evaluate_script "$('#user_dob_day .selected').data('value')"
        expect(day).to eq(user.dob.day)

        target_mth = Date::MONTHNAMES[user.dob.month]
        expect(page).to have_css('#user_dob_month .styleable-select-prompt', text: target_mth)
        month = page.evaluate_script "$('#user_dob_month .selected').data('value')"
        expect(month).to eq(target_mth)

        expect(page).to have_css('#user_dob_year .styleable-select-prompt', text: user.dob.year)
        year = page.evaluate_script "$('#user_dob_year .selected').data('value')"
        expect(year).to eq(user.dob.year)

        expect(page).to have_field('user_password', with: '')
        expect(page).to have_field('user_password_confirmation', with: '')
      end
    end
  end
end
