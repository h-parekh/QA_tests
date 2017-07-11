# frozen_string_literal: true
require 'usurper/usurper_spec_helper'

feature 'Test for Usurper content management API' do
  scenario "Creates, previews, and deletes an entry" do
    ContentfulHandler.create(current_logger: current_logger) do |entry|
      expect(entry).not_to be_published
      # Write a function to preview the entry just created using Content Preview API
      entry.make_previewable!
      visit "/#{entry.slug}?preview=true"
      # Remove the entry created using the Content Management API
      expect(entry).not_to be_deleted
      entry.delete
      expect(entry).to be_deleted
    end
  end
end
