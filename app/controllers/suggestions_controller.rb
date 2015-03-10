class SuggestionsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def create
    suggestion = current_user.suggestions.build(suggestion_params)

    begin
      suggestion.suggest!
      flash[:notice] = I18n.t('layouts.notice.suggestion_create')
    rescue
      flash[:alert] = I18n.t('layouts.alert.suggestion_create_failure')
    end
    redirect_to events_path
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:comment, :user_id)
  end
end
