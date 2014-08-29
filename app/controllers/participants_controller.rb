class ParticipantsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def create
    event_id = participant_params.fetch(:event_id)
    participant = current_user.participants.build(participant_params)
    if participant.create_participant
      flash[:notice] = I18n.t('layouts.notice.participate_event')
    else
      flash[:alert] = I18n.t('layouts.notice.participate_event_failure')
    end
    redirect_to event_path(event_id)
  end

  def destroy
    event_id = participant_params.fetch(:event_id)
    current_user.cancel_participant(event_id)
    redirect_to event_path(event_id), notice: I18n.t('layouts.notice.cancel_participate_event')
  end

  def participant_params
    params.permit(:event_id, :user_id, :comment)
  end
end
