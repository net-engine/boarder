module ApplicationHelper
  def render_flash
    messages = ''
    flash.each do |key, value|
      messages += content_tag :div, class: "flash flash_#{key}" do
        content_tag :span, value, class: "flash_message"
      end
    end
    messages.html_safe
  end
end
