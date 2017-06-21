# frozen_string_literal: true
require 'usurper/usurper_spec_helper'

feature 'Test for Usurper content management API' do
  scenario "Creates an entry" do
    created_entry = ContentfulHandler.new(for_file_path: __FILE__, config: ENV, current_logger: current_logger)
    expect(created_entry).to be_in_contentful
    # Write a function to preview the entry just created using Content Preview API
    # Remove the entry created using the Content Management API
  end
end
