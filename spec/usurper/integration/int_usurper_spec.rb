# frozen_string_literal: true
require 'usurper/usurper_spec_helper'

feature 'Test for Usurper content management API' do
  scenario "Creates, previews, and deletes an entry" do
    ContentfulHandler.create(for_file_path: __FILE__, config: ENV, current_logger: current_logger) do |created_entry|
      expect(created_entry).to be_in_contentful
      # Write a function to preview the entry just created using Content Preview API
      created_entry.make_entry_previewable
      visit "/#{created_entry.slug_for_entry}?preview=true"
      # Remove the entry created using the Content Management API
      created_entry.delete_entry
      expect(created_entry).to be_deleted
    end
  end
end
