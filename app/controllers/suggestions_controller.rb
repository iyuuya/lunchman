class SuggestionsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def show_list
    @suggestions = Suggestion.all.order(created_at: :desc)
  end
end
