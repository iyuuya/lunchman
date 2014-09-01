class EventsController < ApplicationController
  before_action :redirect_login_page_unless_logged_in, except: :show

  def index
    @events = Event.includes(:leader_user).participatable.order(:event_at)
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = current_user.event.build
  end

  def update
    @event = current_user.event.find(params[:id])
    build_params = event_params
    build_params[:event_at] = format_datetime_string(build_params[:event_at_date], build_params[:event_at_time])
    build_params[:deadline_at] = format_datetime_string(build_params[:deadline_at_date], build_params[:deadline_at_time])
    if @event.update(build_params)
      redirect_to @event, notice: I18n.t('layouts.notice.edit_event')
    else
      render :edit
    end
  end

  def edit
    @event = current_user.event.find(params[:id])
    @event.event_at_date = @event.event_at.strftime(I18n.t('date.formats.long'))
    @event.event_at_time = @event.event_at.strftime(I18n.t('time.formats.short'))
    @event.deadline_at_date = @event.deadline_at.strftime(I18n.t('date.formats.long'))
    @event.deadline_at_time = @event.deadline_at.strftime(I18n.t('time.formats.short'))
  end

  def create
    build_params = event_params
    build_params[:event_at] = format_datetime_string(build_params[:event_at_date], build_params[:event_at_time])
    build_params[:deadline_at] = format_datetime_string(build_params[:deadline_at_date], build_params[:deadline_at_time])
    build_params[:status] = Event.statuses[:normal]

    @event = current_user.event.build(build_params)
    if @event.save
      redirect_to events_path, notice: I18n.t('layouts.notice.create_event')
    else
      @event.event_at_date = build_params[:event_at_date]
      @event.event_at_time = build_params[:event_at_time]
      @event.deadline_at_date = build_params[:deadline_at_date]
      @event.deadline_at_time = build_params[:deadline_at_time]

      render :new
    end
  end

  private

  def format_datetime_string(date_string_from_form, time_string_from_form)
    date_string_from_form = date_string_from_form.gsub(/([0-9]+)年([0-9]+)月([0-9]+)日/, '\1/\2/\3')
    Time.strptime('%s %s' % [date_string_from_form, time_string_from_form], '%Y/%m/%d %H:%M %p')
  end

  def event_params
    params.require(:event).permit(:name, :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time, :comment, :max_participants)
  end
end
