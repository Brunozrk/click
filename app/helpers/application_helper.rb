module ApplicationHelper
  def flash_class(type)
    case type
    when 'success' then 'success'
    when 'error' then 'danger'
    when 'notice' then 'info'
    when 'alert' then  'warning'
    end
  end

  def flash_icon(type)
    case type
    when 'success' then 'fa-check'
    when 'error' then 'fa-ban'
    when 'notice' then 'fa-info'
    when 'alert' then 'fa-warning'
    end
  end

  def message(messages)
    return '' if messages.empty?

    messages = messages.map { |msg| content_tag(:p, msg) }.join

    html = <<-HTML
    <div class="callout callout-danger">
      #{messages}
    </div>
    HTML

    html.html_safe
  end

  def popover(content)
    "popover data-toggle='popover' data-content='#{content}'".html_safe
  end
end
