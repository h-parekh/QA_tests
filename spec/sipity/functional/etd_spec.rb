# frozen_string_literal: true
require 'sipity/sipity_spec_helper'

feature 'First Time User', js: true do
  let(:casLogin) { Sipity::Pages::CASLoginPage.new(current_logger, terms_of_service_accepted: false) }
  scenario 'FIRST TIME User Sign In', js: true do
    sign_in
    welcome_page = Sipity::Pages::ETDWelcomePage.new
    expect(welcome_page).to be_on_page
    fill_in("account[preferred_name]", with: 'name')
    find("input[name='account[agreed_to_terms_of_service]']").click
    find("input[value='Continue']")
  end
end

feature 'User Browsing', js: true do
  let(:casLogin) { Sipity::Pages::CASLoginPage.new(current_logger, terms_of_service_accepted: true) }
  scenario 'Visit Homepage' do
    visit_home
  end

  scenario 'RETURN User Sign In', js: true do
    returning_user_sign_in
  end

  scenario 'View Dashboard', js: true do
    returning_user_sign_in
    find_link("Dashboard").click
    dashboard = Sipity::Pages::Dashboard.new
    expect(dashboard).to be_on_page
  end

  scenario 'Start an ETD Submission', js: true do
    returning_user_sign_in
    find_link("Start an ETD Submission").click
    submission_page = Sipity::Pages::ETDSubmissionPage.new
    expect(submission_page).to be_on_page
  end

  scenario 'View Submitted ETDs', js: true do
    returning_user_sign_in
    find_link("View Submitted ETDs").click
    submission_page = Sipity::Pages::SubmittedETDPage.new
    expect(submission_page).to be_on_page
  end

  scenario 'View New Deposit Page', js: true do
    returning_user_sign_in
    find_link("Dashboard").click
    dashboard = Sipity::Pages::Dashboard.new
    expect(dashboard).to be_on_page
    find_link('New Deposit').click
    new_deposit_page = Sipity::Pages::NewDepositPage.new
    expect(new_deposit_page).to be_on_page
  end

  scenario 'Sign Out', js: true do
    returning_user_sign_in
    find_link("Sign out").click
    find('#password')
    find('button[name="submit"]', :text => 'LOGIN')
  end
end

def visit_home
  visit '/'
  home_page = Sipity::Pages::HomePage.new
  expect(home_page).to be_on_page
end

def sign_in
  visit_home
  within('div.collapse.navbar-collapse') do
    find_link('Sign in').click
  end
  expect(casLogin).to be_on_page
  casLogin.complete_login
  sleep(6)
end

def returning_user_sign_in
  sign_in
  signed_in_page = Sipity::Pages::SignedInPage.new
  expect(signed_in_page).to be_on_page
end
