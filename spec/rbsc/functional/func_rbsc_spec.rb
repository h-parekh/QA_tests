# frozen_string_literal: true

require 'rbsc/rbsc_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load homepage', :smoke_test, :read_only do
    visit '/'
    expect(page).to have_content 'Rare Books & Special Collections'
    expect(page).to have_content 'List of Finding Aids'
    within('#main-menu') do
      expect(page).to have_css 'li', count: 5
    end
  end
end
