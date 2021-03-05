module ApplicationHelper

  def full_title(page_title = '')
    title = Globals::App::TITLE
    title += " | #{page_title}" if page_title.present?
    title
  end

  def styleable_select_tag(choices, options = {})
    wrapper_opts = {class: 'styleable-select-wrapper'}
    wrapper_opts[:id] = options[:id] if options[:id].present?
    prompt = options[:prompt].present? ? options[:prompt].capitalize : ''

    tag.div(wrapper_opts) do
      tag.div(class: 'styleable-select') do
        content = tag.div(class: 'styleable-select-trigger') do
          tag.span(prompt, class: 'styleable-select-prompt default').concat(
            tag.div(class: 'styleable-select-toggle') {tag.i class:'fas fa-caret-up'}
          )
        end

        choices = Hash[choices.zip(choices)] if choices.is_a? Array
        content.concat(
          tag.div(class: 'styleable-select-options') do
            choices.collect do |data, value|
              concat(tag.span(value, class: 'styleable-option', 'data-value': data))
            end
          end
        )

        content
      end
    end
  end

end
