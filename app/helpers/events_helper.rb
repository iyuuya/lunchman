module EventsHelper
  def status_participatable(event)
    event.participatable? ? I18n.t('layouts.event_status_participatable') : I18n.t('layouts.event_status_not_participatable')
  end

  def deadline_at(event)
    if event.deadline_at.present?
      event.deadline_at.strftime(I18n.t('time.formats.long'))
    else
      I18n.t('layouts.not_setting')
    end
  end
end
