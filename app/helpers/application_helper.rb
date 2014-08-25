module ApplicationHelper
  def error_messages_for( object )
    return '' if object.errors.blank?

    content_tag :div, class: 'alert-danger' do
      content_tag :ul do
        object.errors.full_messages.each do |message|
          concat content_tag :li, message
        end
      end
    end
  end
end
