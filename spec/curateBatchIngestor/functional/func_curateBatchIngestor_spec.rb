# frozen_string_literal: true
require 'curateBatchIngestor/curateBatchIngestor_spec_helper'

feature 'Load health status page', js: true do
  scenario 'Check version', :smoke_test, :read_only do
    visit '/'
    health_status_page = CurateBatchIngestor::Pages::HealthStatusPage.new
    expect(health_status_page).to be_on_page
  end

  scenario 'Check filesystems work', :smoke_test, :read_only do
    visit '/jobs'
    jobs_status_page = CurateBatchIngestor::Pages::JobsStatusPage.new
    expect(jobs_status_page).to be_on_page
  end
end
