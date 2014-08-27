module EventsHelper
  def status_participable(event)
    event.participable? ? I18n.t('layouts.event_status_participable') : I18n.t('layouts.event_status_not_participable')
  end

  def deadline_at(event)
    if event.deadline_at.present?
      event.deadline_at.strftime('%Y年%m月%d日 %H:%M %p')
    else
      I18n.t('layouts.not_setting')
    end
  end

  def max_paticipants(event)
    if event.max_paticipants.present?
      '%s %s' % [event.max_paticipants, I18n.t('layouts.paticipant_unit')]
    else
      I18n.t('layouts.not_setting')
    end
  end
end
