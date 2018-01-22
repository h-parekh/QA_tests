# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only, :smoke_test do
    visit '/'
    home_page = Seaside::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Visit About Seaside - Community Page', :read_only do
    visit '/'
    click_on('About Seaside')
    find_link('The Community & Building the Portal').trigger('click')
    community_page = Seaside::Pages::CommunityPage.new
    expect(community_page).to be_on_page
  end

  scenario 'Visit About Seaside - History Page', :read_only do
    visit '/'
    click_on('About Seaside')
    find_link(href: '/essays/seaside-history').trigger('click')
    history_page = Seaside::Pages::HistoryPage.new
    expect(history_page).to be_on_page
  end

  scenario 'Visit About Seaside - Oral History Page', :read_only do
    visit '/'
    click_on('About Seaside')
    find_link(href: '/essays/oral-histories').trigger('click')
    oral_hist_page = Seaside::Pages::OralHistPage.new
    expect(oral_hist_page).to be_on_page
  end

  scenario 'Visit About Seaside - All', :read_only do
    visit '/'
    click_on('About Seaside')
    find_link('All', href:'/about').trigger('click')
    about_page = Seaside::Pages::AboutPage.new
    expect(about_page).to be_on_page
  end
end
