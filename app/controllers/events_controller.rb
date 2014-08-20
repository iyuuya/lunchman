class EventsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def new
    @event = current_user.event.build
  end



  def create
    build_prms = {}

    prms = event_params
    build_prms[:name]  = prms[:name]

    build_prms[:event_at] = Date.strptime("%s %s" % [prms[:event_at_date], prms[:event_at_time]], "%Y/%m/%d %H:%M")
    build_prms[:deadline_at] = Date.strptime("%s %s" % [prms[:deadline_at_date], prms[:deadline_at_time]], "%Y/%m/%d %H:%M")

    build_prms[:comment]  = prms[:comment]
    build_prms[:max_paticipants]  = prms[:max_paticipants]

    build_prms[:status]  = Event::STATUS_NORMAL

    @event = current_user.event.build( build_prms )
    if @event.save
      redirect_to list_events_path, notice:  I18n.t("layouts.notice.create_event")
    else
      render :new
    end

  end


  private
  def event_params
    params.require(:event).permit(:name, :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time, :comment, :max_paticipants)
  end
end
