require 'microfilms/microfilms_spec_helper'

feature 'User Browsing', :js => true do
    scenario 'Test 1: Enter text in search box' do
      visit '/'
      puts current_url

      within('.search') do
        expect(page).to have_field 'q', type: 'text'
        expect(page).to have_button 'search'
        fill_in('q', with: 'Roman')
        click_on('search')
        print "Clicked search\n"
      end

      within('#appliedParams') do
          expect(page).to have_link 'startOverLink'
      end

    end
end
