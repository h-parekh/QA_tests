# frozen_string_literal: true
require 'osf/osf_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)', :read_only do
    visit '/'
    click_on('Sign In')
    page.has_selector?('#alternative-institution')
    find('#alternative-institution').click
    find('#institution-form-select').click
    page.has_field?('option' ,text: 'University of Notre Dame')
    page.select('University of Notre Dame')
    find('input[name=submit]').trigger(:click)
    login_page.completeLogin
    expect(page).to have_selector('.dropdown-toggle.nav-user-dropdown')
    # This selector is the user dropdown menu that only appears with a successful login
  end
end
