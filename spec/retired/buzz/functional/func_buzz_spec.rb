# frozen_string_literal: true

require 'buzz/buzz_spec_helper'

feature 'Verify a media file', js: true do
  scenario 'Returns valid JSON', :smoke_test, :read_only do
    visit '/v1/media_files/31112b1e-6a1a-4307-8d00-d298a5c0a6ed'
    response = Buzz::BuzzPlayer.new
    expect(response).to be_valid_response
  end
end
