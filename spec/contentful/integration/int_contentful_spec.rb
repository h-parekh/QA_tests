# frozen_string_literal: true
require 'contentful/contentful_spec_helper'

feature 'Test for Usurper content management API' do
  scenario "Checks webhooks; creates, previews, and deletes an entry" do
    ContentfulHandler.create(current_logger: current_logger) do |entry|
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
