# frozen_string_literal: true
require 'osf/osf_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { OSF::Pages::LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)' do
    login_page.completeLogin
    expect(page).to have_selector('.dropdown-toggle.nav-user-dropdown')
    # This selector is the user dropdown menu that only appears with a successful login
  end
end
