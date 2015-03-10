ActiveAdmin.register Event do
  actions :index, :show, :destroy

  action_item :participants, only: :show do
    link_to I18n.t('activerecord.models.participant'), admin_event_participants_path(event)
  end
end
