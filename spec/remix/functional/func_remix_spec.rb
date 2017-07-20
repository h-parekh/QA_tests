# frozen_string_literal: true
require 'remix/remix_spec_helper'

feature 'Institutional Login', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario 'Sign in by institution (Notre Dame)', :validates_login do
    visit '/Shibboleth.sso/Login?target=https%3A%2F%2Fremix.nd.edu%2F%3Fq%3Dshib_login%2Fnode%2F27'
    login_page.completeLogin
    expect(page).to have_selector('.header__site-link')
    expect(current_url).to eq('https://remix.nd.edu/?q=node/27')
  end
end
