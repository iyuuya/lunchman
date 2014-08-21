require 'rails_helper'

describe "event_create" do

  describe "fill_in form" do
    include_context "fill_in_event_new_form", is_click_button: false

    it 'increse event count' do
      expect{ click_button I18n.t('layouts.event_new_label') }.to change( Event, :count ).by(1)
    end

  end


  describe "fill_in form" do
    include_context "fill_in_event_new_form", is_click_button: true

    # before do
    #   visit new_event_path
    #   click_button I18n.t('layouts.event_new_label')
    # end

    it 'redirect to events#index 'do
      expect( page.current_path ).to eq events_path
    end

    it 'no error classes in css' do
      expect( page ).not_to have_css('div.alert-danger')
    end

  end
end
