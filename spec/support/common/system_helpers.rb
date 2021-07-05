module SystemHelpers
  def resize_window_to_default
    resize_window_to(1440, 900)
  end

  def resize_window_to_xs
    resize_window_to(575, 900)
  end

  def resize_window_to_small
    resize_window_to(767, 900)
  end

  def resize_window_to_medium
    resize_window_to(768, 900)
  end

  def page_should_reload
    page.evaluate_script "$(document.body).addClass('not-reloaded')"
    yield
    sleep 0.1
    expect(page).to have_no_selector("body.not-reloaded")
  end

  def page_should_not_reload
    page.evaluate_script "$(document.body).addClass('not-reloaded')"
    yield
    sleep 0.1
    expect(page).to have_selector("body.not-reloaded")
  end

  def reload_page
    page.driver.browser.navigate.refresh
  end

  def gui_login_user(user)
    visit '/login'
    fill_in 'session_username', with: user.username
    fill_in 'session_password', with: user.password
    find(".btn[value=login]").click
    sleep 0.1
  end

  def expect_user_panel(username)
    expect(page).to have_css('.navbar-user-panel')
    expect(page).to have_css('.gravatar')
    expect(page).to have_css('.navbar-username', text: username)
  end

  def expect_no_user_panel
    expect(page).to have_no_css('.navbar-user-panel')
  end

  def expect_static_pages_links
    expect(page).to have_link('About', href: '#')
    expect(page).to have_link('Features', href: '#')
    expect(page).to have_link('Sample Link', href: '#')
  end

  def expect_no_static_pages_links
    expect(page).to have_no_link('About', href: '#')
    expect(page).to have_no_link('Features', href: '#')
    expect(page).to have_no_link('Sample Link', href: '#')
  end

  def has_field_with_label(field_name, label_text)
    expect(page).to have_css "label[for=#{field_name}]", text: icase_exact(label_text)
    expect(page).to have_field field_name
  end

  def find_and_click_styleable_select_option(field_id, target_value)
    find("#{field_id} .styleable-select").click
    find("#{field_id} .styleable-option[data-value='#{target_value}']").click
  end


  private

    def resize_window_to(width, height)
      if Capybara.current_session.driver.browser.respond_to? 'manage'
        Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
      end
    end
end

RSpec.configure do |config|
  config.include SystemHelpers, type: :system
end
