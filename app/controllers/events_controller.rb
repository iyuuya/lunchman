class EventsController < ApplicationController
  before_action :redirect_login_page_unless_logged_in

  def index
    @events = Event.includes(:leader_user).participatable.order(:event_at)
    @current_user_participant_events = current_user.participating_events.not_held.order('events.event_at')
    @leader_events = Event.where(leader_user_id: current_user).not_held
  end

  def show
    @event = Event.find(params[:id])
    @participants = @event.participants.includes(:user).order(:created_at)
    @participant_for_form = @event.participants.build(user_id: current_user)
  end

  def new
    @event = current_user.event.build
  end

  def update
    begin
      @event = current_user.event.find(params[:id])
      @event.update_event!(event_params)
      redirect_to @event, notice: I18n.t('layouts.notice.edit_event')
    rescue
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
      @event = Event.find(params[:event_id])
      @participant_for_form = current_user.participants.build(event_id: params[:event_id])
      @participant_for_form.participate!(participant_params.fetch(:comment))

      flash[:notice] = I18n.t('layouts.notice.participate_event')
      redirect_to event_path(params[:event_id])
    rescue
      render :show
    end
  end

  def cancel_participate
    begin
      participant = current_user.participants.find_by!(event_id: params[:event_id])
      participant.cancel_participant!
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

  def participant_params
    params.require(:participant).permit(:comment)
  end
end
