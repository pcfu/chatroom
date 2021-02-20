module ApplicationHelper

  def full_title(page_title = '')
    title = Globals::App::TITLE
    title += " | #{page_title}" if page_title.present?
    title
  end

end
