module EventsHelper
  def status_participatable(event)
    event.participatable? ? I18n.t('layouts.event_status_participatable') : I18n.t('layouts.event_status_not_participatable')
  end

  def status(event)
    if event.normal?
      I18n.t('event_status.normal')
    elsif event.cancel?
      I18n.t('event_status.cancel')
    elsif event.participants_max?
      I18n.t('event_status.participants_max')
    end
  end

  def status_html(event)
    if event.normal?
      option = {}
    else
      option = {class: 'text-danger'}
    end
    content_tag :span, self.status(event), option
  end

  def deadline_at(event)
    if event.deadline_at.present?
      event.deadline_at.strftime(I18n.t('time.formats.long'))
    else
      I18n.t('layouts.not_setting')
    end
  end
end
