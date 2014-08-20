class EventsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def new
    @event = current_user.event.build
  end



  def create
    prms = event_params

    prms[:event_at] = Date.strptime("%s %s" % [prms[:event_at_date], prms[:event_at_time]], "%Y/%m/%d %H:%M")
    prms[:deadline_at] = Date.strptime("%s %s" % [prms[:deadline_at_date], prms[:deadline_at_time]], "%Y/%m/%d %H:%M")

    prms[:status]  = Event::STATUS_NORMAL

    @event = current_user.event.build( prms )

    if @event.save
      redirect_to list_events_path, notice:  I18n.t("layouts.notice.create_event")
    else
      @event.event_at_date = prms[:event_at_date]
      @event.event_at_time = prms[:event_at_time]
      @event.deadline_at_date = prms[:deadline_at_date]
      @event.deadline_at_time = prms[:deadline_at_time]

      render :new
    end

  end





  private
  def event_params
    params.require(:event).permit(:name, :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time, :comment, :max_paticipants)
  end
end
