# frozen_string_literal: true

require 'sipity/sipity_spec_helper'
def visit_home
  visit '/'
  home_page = Sipity::Pages::HomePage.new
  expect(home_page).to be_on_page
end

def sign_in
  within('div.collapse.navbar-collapse') do
    find_link('Sign in').click
  end
  expect(casLogin).to be_on_page
  casLogin.complete_login
end

def sign_out_from_sipity
  find_link("Sign out").click
  expect(casLogin).to be_on_page
end

feature 'First time user', js: true do
  let(:casLogin) { LoginPage.new(current_logger, terms_of_service_accepted: false) }

  scenario 'Sign In', :validates_login, :read_only, js: true do
    visit_home
    sign_in
    welcome_page = Sipity::Pages::ETDWelcomePage.new
    expect(welcome_page).to be_on_page
    fill_in("account[preferred_name]", with: 'name')
    find("input[name='account[agreed_to_terms_of_service]']").click
    find("input[value='Continue']")
  end
end

feature 'Returning User', js: true do
  let(:casLogin) { LoginPage.new(current_logger, terms_of_service_accepted: true) }

  scenario 'Browsing dashboard', :smoke_test, :read_only do
    visit_home
    sign_in
    signed_in_page = Sipity::Pages::SignedInPage.new
    expect(signed_in_page).to be_on_page
    # Tests 'Dashboard'
    find_link("Dashboard").click
    dashboard = Sipity::Pages::Dashboard.new
    expect(dashboard).to be_on_page
    # Tests 'New Deposit page'
    find_link('New Deposit').click
    new_deposit_page = Sipity::Pages::NewDepositPage.new
    expect(new_deposit_page).to be_on_page
    sign_out_from_sipity
  end

  scenario 'Browse ETD buttons', :read_only, js: true do
    visit_home
    sign_in
    find_link("Start an ETD Submission").click
    submission_page = Sipity::Pages::ETDSubmissionPage.new
    expect(submission_page).to be_on_page
    page.go_back
    # Tests 'View Submitted ETDs'
    find_link("View Submitted ETDs").click
    submission_page = Sipity::Pages::SubmittedETDPage.new
    expect(submission_page).to be_on_page
  end
end
