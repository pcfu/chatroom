module CommonHelpers
  def generate_blanks(type: String, include_nil: true)
    blanks = include_nil ? [ nil ] : [ ]
    blanks += [ '', '     ' ] if type == String
    return blanks
  end

  def resize_window_to_small
    resize_window_to(767, 1080)
  end

  def resize_window_to_medium
    resize_window_to(768, 1080)
  end

  def resize_window_to_default
    resize_window_to(1920, 1080)
  end

  def icase_exact(string)
    /\A#{string}\z/i
  end

  def has_field_with_label(field_name, label_text)
    expect(page).to have_css "label[for=#{field_name}]", text: icase_exact(label_text)
    expect(page).to have_field field_name
  end


  private

    def resize_window_to(width, height)
      if Capybara.current_session.driver.browser.respond_to? 'manage'
        Capybara.current_session.driver.browser.manage.window.resize_to(width, height)
      end
    end
end

RSpec.configure do |config|
  config.include CommonHelpers
end
