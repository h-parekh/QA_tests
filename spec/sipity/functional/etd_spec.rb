# frozen_string_literal: true
require 'sipity/sipity_spec_helper'


feature 'User Browsing', js: true do
  scenario 'Visit Homepage' do
    visitHome
  end

  scenario 'FIRST TIME User Sign In', js: true do
    signIn
    welcome_page = Curate::Pages::ETDWelcomePage.new
    expect(welcome_page).to be_on_page
    fill_in("account[preferred_name]",with: 'name')
    find("input[name='account[agreed_to_terms_of_service]']").click
    find("input[value='Continue']").click
    signed_in_page = Curate::Pages::SignedInPage.new
    expect(signed_in_page).to be_on_page
  end

  scenario 'RETURN User Sign In', js: true do
    returnSignIn
  end

  scenario 'View Dashboard', js: true do
    returnSignIn
    find_link("Dashboard").click
    dashboard = Curate::Pages::Dashboard.new
    expect(dashboard).to be_on_page
  end

  scenario 'Start and ETD Submission', js: true do
    returnSignIn
    find_link("Start an ETD Submission").click
    submission_page = Curate::Pages::ETDSubmissionPage.new
    expect(submission_page).to be_on_page
  end

  scenario 'View Submitted ETDs', js: true do
    returnSignIn
    find_link("View Submitted ETDs").click
    submission_page = Curate::Pages::SubmittedETDPage.new
    expect(submission_page).to be_on_page
  end

  scenario 'View New Deposit Page', js: true do
    returnSignIn
    find_link("Dashboard").click
    dashboard = Curate::Pages::Dashboard.new
    expect(dashboard).to be_on_page
    find_link('New Deposit').click
    new_deposit_page = Curate::Pages::NewDepositPage.new
    expect(new_deposit_page).to be_on_page
  end

  scenario 'Sign Out', js: true do
    returnSignIn
    find_link("Sign out").click
    find('#password')
    find('button[name="submit"]', :text => 'LOGIN')
  end
end

def visitHome
  visit '/'
  home_page = Curate::Pages::HomePage.new
  expect(home_page).to be_on_page
end

def signIn
  visitHome
  within('div.collapse.navbar-collapse') do
    find_link('Sign in').click
  end
  casLogin = Curate::Pages::CASLoginPage.new(current_logger )
  expect(casLogin).to be_on_page
  casLogin.completeLogin
  sleep(6)
end


def returnSignIn
  signIn
  signed_in_page = Curate::Pages::SignedInPage.new
  expect(signed_in_page).to be_on_page
end
