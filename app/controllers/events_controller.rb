class EventsController < ApplicationController
  before_action :redirect_login_page_unless_logged_in

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
    if @event.update(event_params)
      redirect_to @event, notice: I18n.t('layouts.notice.edit_event')
    else
      render :edit
    end
  end

  def edit
    @event = current_user.event.find(params[:id])
    @event.set_separated_datetime
  end

  def destroy
    current_user.cancel_event(params[:id])
    redirect_to root_path, notice: I18n.t('layouts.notice.cancel_event')
  end

  def create
    build_params = event_params
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

  def participate
    begin
      event = Event.find(params[:event_id])
      event.participate!(current_user, event_params.fetch(:participant_comment))
      flash[:notice] = I18n.t('layouts.notice.participate_event')
    rescue
      flash[:alert] = I18n.t('layouts.alert.participate_event_failure')
    end
    redirect_to event_path(params[:event_id])
  end

  def cancel_participate
    begin
      event = Event.find(params[:event_id])
      event.cancel_participant!(current_user)
      flash[:notice] = I18n.t('layouts.notice.cancel_participate_event')
    rescue
      flash[:alert] = I18n.t('layouts.alert.cancel_participate_event_failure')
    end
    redirect_to event_path(params[:event_id])
  end

  private

  def event_params
    params.require(:event).permit(:name, :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time, :comment, :max_participants, :participant_comment)
  end
end
