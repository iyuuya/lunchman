require 'rails_helper'

describe "event_create" do

  context "fill_in form" do
    include_context "login_and_fillin_form"

    it 'increse event count' do
      expect{ click_button I18n.t('layouts.event_new_label') }.to change( Event, :count ).by(1)
    end

  end


  context "fill_in form" do
    include_context "login_and_fillin_form"

    before do
      click_button I18n.t('layouts.event_new_label')
    end

    it 'redirect to events#index 'do
      expect( page.current_path ).to eq events_path
    end

    it 'no error classes in css' do
      expect( page ).not_to have_css('div.alert-danger')
    end

  end
end
