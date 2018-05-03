# frozen_string_literal: true

require 'hathitrust/hathitrust_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)', :validates_login, :read_only do
    visit '/'
    find('#login-button').trigger('click')
    find('.button.continue').click
    login_page.complete_login
    expect(page).to have_link('My Collections')
    expect(page).to have_link('Logout')
  end
end
