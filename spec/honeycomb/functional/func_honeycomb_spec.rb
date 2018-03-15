# frozen_string_literal: true
require 'osf/osf_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)', :read_only, :validates_login do
    visit '/'
    login_page.completeLogin
    expect(page).to have_selector('.glyphicon-log-out')
  end
end
