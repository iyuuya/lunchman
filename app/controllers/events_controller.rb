class EventsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def new
    @event = current_user.event.build
  end



  def create
    prms = event_params
    prms[:status]  = Event::STATUS_NORMAL

    event = current_user.event.build( prms )
    event.save!

    redirect_to list_events_path, notice: I18n.t("layouts.notice.create_event")

  end


  private
  def event_params
    params.require(:event).permit(:name, :event_at, :deadline_at, :comment, :max_paticipants)
  end
end
