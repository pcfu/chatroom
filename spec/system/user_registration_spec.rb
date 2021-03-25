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

  scenario "user creates a new account", js: true do
    user = build_stubbed(:user)

    visit register_path
    fill_in :user_username, with: user.username
    fill_in :user_email, with: user.email

    mth = Date::MONTHNAMES[user.dob.month]
    scroll_y = page.evaluate_script("$('.styleable-option:nth-child(1)').outerHeight(true)") * 5

    find("#user_dob_day .styleable-select").click
    while true
      break if find("#user_dob_day .styleable-option[data-value='#{user.dob.day}']")
      find("#user_dob_day .styleable-select-options").scroll_to(0, scroll_y)
      scroll_y += scroll_y
    end
    find("#user_dob_day .styleable-option[data-value='#{user.dob.day}']").click

    find("#user_dob_month .styleable-select").click
    while true
      break if find("#user_dob_month .styleable-option[data-value='#{mth}']")
      find("#user_dob_month .styleable-select-options").scroll_to(0, scroll_y)
      scroll_y += scroll_y
    end
    find("#user_dob_month .styleable-option[data-value='#{mth}']").click

    find("#user_dob_year .styleable-select").click
    while true
      break if find("#user_dob_year .styleable-option[data-value='#{user.dob.year}']")
      find("#user_dob_year .styleable-select-options").scroll_to(0, scroll_y)
      scroll_y += scroll_y
    end
    find("#user_dob_year .styleable-option[data-value='#{user.dob.year}']").click

    fill_in :user_password, with: user.password
    fill_in :user_password_confirmation, with: user.password_confirmation

    expect {
      find(".btn[value=register]").click
    }.to change(User.all, :count).by(1)
  end
end
