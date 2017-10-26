#frozen_string_literal: true
require 'monarchLibguides/monarchLibguides_spec_helper'

feature 'monarchLibguides API tests' do
  SwaggerHandler.operations(for_file_path: __FILE__).each do |operation|
    scenario "calls #{operation.verb} #{operation.path}" do
      schema = RequestBuilder.new(current_logger, operation)
      result = schema.send_via_operation_verb
      current_response = ResponseValidator.new(operation, result)
      expect(current_response).to be_valid_response
    end
  end
end

# This scenario is testing the /newevent endpoint of monarch_libguides API
# https://github.com/ndlib/monarch_libguides/blob/master/deploy/gateway.yml
# I am calling /newevent via contentful to make sure the webhooks are firing
# correctly, and the event is then previewable
feature 'Test for libguides event updater' do
  scenario "Checks webhooks; creates an event, saves it, wait 30 sec, preview and deletes libduige entry" do
    ContentfulHandler.create(current_logger: current_logger, content_type: 'event', lib_cal_id: '3596276') do |entry|
      require 'byebug'; debugger
      entry.verify_webhooks
      expect(entry).not_to be_published
      # Preview the entry just created using Content Preview API
      entry.make_previewable!
      visit "/#{entry.slug}?preview=true"
      test_page_preview = ContentfulTests::Pages::TestPagePreview.new(contentful_entry: entry)
      expect(test_page_preview).to be_on_page
      expect(entry).not_to be_deleted
      # Remove the entry created using the Content Management API
      entry.delete
      expect(entry).to be_deleted
    end
  end
end
