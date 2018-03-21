# frozen_string_literal: true
require 'bendo/bendo_spec_helper'

feature 'Load health status page', js: true do
  scenario 'Check version', :smoke_test, :read_only do
    visit '/'
    health_status_page = Bendo::Pages::HealthStatusPage.new
    expect(health_status_page).to be_on_page
  end
end
