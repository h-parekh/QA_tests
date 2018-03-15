# frozen_string_literal: true
require 'contentful/contentful_spec_helper'

# Both these scenarios are adding content in production but I'm still tagging
# them as ':read_only' because they have a built in mechanism to cleanup
# test data before finishing  the scenarios
feature 'Tests for Contentful entries and webhook integrations' do
  scenario "Create and preview an entry of type 'Page'", :read_only do
    ContentfulHandler.create(current_logger: current_logger) do |entry|
      entry.verify_webhooks
      expect(entry).not_to be_published
      # Preview the entry just created using Content Preview API
      entry.make_previewable!
      visit "/#{entry.slug}?preview=true"
      page_entry_preview = ContentfulTests::Pages::PageEntryPreview.new(contentful_entry: entry)
      expect(page_entry_preview).to be_on_page
      expect(entry).not_to be_deleted
      # Remove the entry created using the Content Management API
      entry.delete
      expect(entry).to be_deleted
    end
  end

  # This scenario is testing the /newevent endpoint of monarch_libguides API
  # https://github.com/ndlib/monarch_libguides/blob/master/deploy/gateway.yml
  # I am calling /newevent via contentful to make sure the webhooks are firing
  # correctly, and the event is then previewable
  # 'lib_cal_id' is a unique ID that is used to pull data from the libcal system
  # libcal ID is parameterized by leveraging the PathParameterizer::ParameterFinder
  # class along with the associated find method of ParameterFinder
  scenario "Create and preview an entry of type 'Events'", :read_only do
    contentful_params = PathParameterizer::ParameterFinder.new(application_name_under_test: 'contentful')
    lib_cal_id = contentful_params.find(key: 'libCalId').to_s
    ContentfulHandler.create(current_logger: current_logger, content_type: 'event', lib_cal_id: lib_cal_id ) do |entry|
      entry.verify_webhooks
      expect(entry).not_to be_published
      # This isn't elegant but necessary in this case, because we want to wait for the
      # new event to reach out to Libcal via the monarchLibguides /newevent endpoint
      # and update event information.
      sleep(10)
      # At this point the event entry should have been updated in contentful, so we need to refresh it
      entry.refresh_entry
      entry.make_previewable!
      visit "/event/#{entry.slug}?preview=true"
      event_entry_preview = ContentfulTests::Pages::EventEntryPreview.new(contentful_entry: entry)
      expect(event_entry_preview).to be_on_page
      expect(entry).not_to be_deleted
      # Remove the entry created using the Content Management API
      entry.delete
      expect(entry).to be_deleted
    end
  end
end
