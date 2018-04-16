# frozen_string_literal: true
require 'curate/curate_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage', :read_only do
    visit '/'
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Go to About page', :read_only do
    visit '/'
    click_on('About')
    about_page = Curate::Pages::AboutPage.new
    expect(about_page).to be_on_page
  end

  scenario 'Go to FAQ page', :read_only do
    visit '/'
    click_on('FAQ')
    faq_page = Curate::Pages::FaqPage.new
    expect(faq_page).to be_on_page
  end

  scenario 'Go to catalog search page with empty search term', :read_only do
    visit '/'
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new({})
    expect(catalog_page).to be_on_page
  end

  scenario 'Go to catalog search page with term "Article"', :smoke_test, :read_only do
    visit '/'
    search_term = "Article"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new(search_term: search_term)
    expect(catalog_page).to be_on_page
    click_on('Clear all')
    expect(catalog_page).to be_on_base_url
  end

  scenario 'Category search for All Items', :read_only do
    visit '/'
    title = 'All Items'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new({})
    expect(category_page).to be_on_page
  end

  scenario 'Category search for Articles', :read_only do
    visit '/'
    title = 'Articles & Publications'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :article)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Category search for Datasets', :read_only do
    visit '/'
    title = 'Datasets & Related Items'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :dataset)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Contribute Your Work', :smoke_test, :read_only do
    visit '/'
    click_on('Contribute Your Work')
    contribute_page = Curate::Pages::ContributePage.new
    expect(contribute_page).to be_on_page
  end

  scenario 'Items by Department link', :read_only do
    visit '/'
    click_on('Items by Department')
    dept_page = Curate::Pages::DepartmentsPage.new
    expect(dept_page).to be_on_page
    departmental_link = dept_page.select_random_departmental_link
    dept_search_page = Curate::Pages::CatalogPage.new(category: :department, departmental_link: departmental_link)
    visit departmental_link.link
    expect(dept_search_page).to be_on_page
  end

  scenario "Show an Article", :read_only do
    visit '/'
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
    search_term = "Article"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new(search_term: search_term)
    expect(catalog_page).to be_on_page
    article_link = first('a[id^="src_copy_link"]')
    show_article = Curate::Pages::ShowArticlePage.new(title: article_link.text)
    article_link.click
    expect(show_article).to be_on_page
  end
end

feature 'Requesting Help', js: true do
  scenario 'Go to help page', :read_only do
    visit '/'
    click_on('Help')
    help_page = Curate::Pages::ModalHelpPage.new
    expect(help_page).to be_on_page
    fill_in('help_request_name', with: 'some name')
    click_on('Submit')
    expect(page).to have_selector('#ajax-modal', visible: true)
  end
end

feature 'Facet Navigation', js: true do
  scenario "modal facets", :read_only do
    visit '/'
    click_on('Search')
    ['Department or Unit', 'Collection'].shuffle.each do |facet_name|
      current_logger.info(context: "Processing Facet: #{facet_name}")
      expect(page).not_to have_selector("#ajax-modal", visible: true)
      within('.facets') do
        click_on(facet_name)
      end
      expect(page).to have_selector('#ajax-modal', visible: true)
      expect(page).to have_content(facet_name)
      within('#ajax-modal') do
        find('.close').trigger('click')
      end
      expect(page).not_to have_selector("#ajax-modal", visible: true)
    end
  end

  scenario 'non-modal Facets', :read_only do
    visit '/'
    click_on('Search')
    ['Type_of_Work', 'Creator', 'Subject', 'Language', 'Publisher', 'Academic_Status'].shuffle.each do |facet_name|
      current_logger.info(context: "Processing Facet: #{facet_name}")
      expect(page).not_to have_css("ul.facets #collapse_#{facet_name}.in")
      find("ul.facets a[data-target=\"#collapse_#{facet_name}\"]").trigger('click')
      expect(page).to have_css("ul.facets #collapse_#{facet_name}.in .slide-list")
    end
  end
end

feature 'Logged In User (Account details NOT updated) Browsing', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario "Log in", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
  end

  scenario "Manage My Works", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Works")
    works_page = Curate::Pages::MyWorksPage.new
    expect(works_page).to be_on_page
  end

  scenario "Visit Manage My Groups page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Groups")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Manage My Collections page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Collections")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Manage My Profile page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Profile")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Deposit New Article page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Article")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Deposit New Dataset page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Dataset")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Deposit New Document page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Document")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Deposit New Image page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Image")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit More Options page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("More Options")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Deposit New Audio page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("More Options")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Visit Deposit New Senior Thesis page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("More Options")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
  end

  scenario "Log out", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(page).not_to have_selector('.form-signin [name=submit]')
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("Log Out")
    login_page.checkLoginPage
  end
end

feature 'Logged In User (Account details updated) Browsing', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: true) }
  scenario "Log in", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
  end

  scenario "Manage My Works", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Works")
    works_page = Curate::Pages::MyWorksPage.new
    expect(works_page).to be_on_page
  end

  scenario "Visit Manage My Groups page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Groups")
    groups_page = Curate::Pages::MyGroupsPage.new
    expect(groups_page).to be_on_page
  end

  scenario "Visit Manage My Collections page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Collections")
    collections_page = Curate::Pages::MyCollectionsPage.new
    expect(collections_page).to be_on_page
  end

  scenario "Visit Manage My Profile page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Profile")
    profile_page = Curate::Pages::MyProfilePage.new
    expect(profile_page).to be_on_page
  end

  scenario "Visit Manage My Delegates page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Delegates")
    delegates_page = Curate::Pages::MyDelegatesPage.new
    expect(delegates_page).to be_on_page
  end

  scenario "Visit Deposit New Article page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Article")
    article_page = Curate::Pages::ArticlePage.new
    expect(article_page).to be_on_page
  end

  scenario "Visit Deposit New Dataset page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Dataset")
    dataset_page = Curate::Pages::DatasetPage.new
    expect(dataset_page).to be_on_page
  end

  scenario "Visit Deposit New Document page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Document")
    document_page = Curate::Pages::DocumentPage.new
    expect(document_page).to be_on_page
  end

  scenario "Visit Deposit New Image page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("New Image")
    image_page = Curate::Pages::ImagePage.new
    expect(image_page).to be_on_page
  end

  scenario "Visit More Options page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("More Options")
    options_page = Curate::Pages::StartDepositPage.new
    expect(options_page).to be_on_page
  end

  scenario "Visit Deposit New Audio page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("More Options")
    options_page = Curate::Pages::StartDepositPage.new
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_audio').click
    audio_page = Curate::Pages::AudioPage.new
    expect(audio_page).to be_on_page
  end

  scenario "Visit Deposit New Senior Thesis page", :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on("More Options")
    options_page = Curate::Pages::StartDepositPage.new
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_senior_thesis').click
    thesis_page = Curate::Pages::ThesisPage.new
    expect(thesis_page).to be_on_page
  end

  scenario "Log out" do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("Log Out")
    login_page.checkLoginPage
  end
end

feature 'Embargo scenarios:', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: true) }
  scenario "Create Embargo Work", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    # To test if the ebargo date requirement works
    image_page.createTempImage(access_rights: 'embargo', embargo_date: false)
    # Since there is no embargo date the url should not change
    expect(current_url).to include('concern/images/new')
    fill_in(id: 'image_embargo_release_date', with: Date.today+1)
    find('.btn.btn-primary.require-contributor-agreement').trigger('click')
    expect(page).to have_css('.label.label-warning', text: "Under Embargo")
    expect(current_url).not_to include('concern/images/new')
    find_link('Delete').trigger('click')
  end


  scenario "Changing Work Access Rights to Embargo without Filling in Date Should Not Work", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    image_page.createTempImage(access_rights: 'restricted')
    expect(page).to have_css('.main-header', text: "foo") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.page-actions') do
      click_on('Edit')
    end
    within('#set-access-controls') do
      choose(id: 'visibility_embargo')
    end
    # To test that the embargo date requirement works
    find('.btn.btn-primary.require-contributor-agreement').trigger('click')
    expect(current_url).not_to include('confirm')
    fill_in(id: 'image_embargo_release_date', with: Date.today+1)
    find('.btn.btn-primary.require-contributor-agreement').trigger('click')
    expect(page).to have_css('.span12', text: "You've changed this foo to be open_with_embargo_release_date") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.button_to') do
      find('.btn.btn-primary').trigger('click')
    end
    expect(page).to have_css('.label.label-warning', text: "Under Embargo")
    find_link('Delete').trigger('click')
  end

  scenario "Changing Work Access Rights from Embargo to Open", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    image_page.createTempImage(access_rights: 'embargo')
    expect(page).to have_css('.main-header', text: "foo") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.page-actions') do
      click_on('Edit')
    end
    within('#set-access-controls') do
      choose(id: 'visibility_open')
    end
    find('.btn.btn-primary.require-contributor-agreement').trigger('click')
    expect(page).to have_css('.span12', text: "You've changed this foo to be open.") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.button_to') do
      find('.btn.btn-primary').trigger('click')
    end
    # Make sure the Access Control switches to Open
    expect(page).to have_css('.label.label-success', text: "Open Access")
    find_link('Delete').trigger('click')
  end

  scenario "Changing Work Access Rights from Registered to Embargo", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openAddContentDrawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    image_page.createTempImage(access_rights: 'ndu')
    expect(page).to have_css('.main-header', text: "foo") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.page-actions') do
      click_on('Edit')
    end
    within('#set-access-controls') do
      choose(id: 'visibility_embargo')
    end
    fill_in(id: 'image_embargo_release_date', with: Date.today+1)
    find('.btn.btn-primary.require-contributor-agreement').trigger('click')
    expect(page).to have_css('.span12', text: "You've changed this foo to be open_with_embargo_release_date") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.button_to') do
      find('.btn.btn-primary').trigger('click')
    end
    expect(page).to have_css('.label.label-warning', text: "Under Embargo")
    find_link('Delete').trigger('click')
  end
end

feature 'Logged in user changing ORCID settings (Account Details Not Updated):', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario "Go to ORCID.org Signin page", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Profile")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    find_link('ORCID Settings').trigger('click')
    sleep(1)
    orcid_settings_page = Curate::Pages::OrcidSettingsPage.new
    expect(orcid_settings_page).to be_on_page
    find_link('Create or Connect your ORCID iD').trigger('click')
    sleep(1)
    orcid_home_page = Curate::Pages::OrcidHomePage.new
    expect(orcid_home_page).to be_on_page(login_page.account_details_updated)
  end
end

feature 'Logged in user changing ORCID settings (Account Details Updated):', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: true) }
  scenario "Go to ORCID.org registration page", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.openActionsDrawer
    click_on("My Profile")
    click_on("Update Personal Information")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    find_link('ORCID Settings').trigger('click')
    sleep(1)
    orcid_settings_page = Curate::Pages::OrcidSettingsPage.new
    expect(orcid_settings_page).to be_on_page
    find_link('Create or Connect your ORCID iD').trigger('click')
    sleep(1)
    orcid_home_page = Curate::Pages::OrcidHomePage.new
    expect(orcid_home_page).to be_on_page(login_page.account_details_updated)
  end
end

feature 'Featured Collections:', js: true do
  scenario 'Patents', :read_only do
    visit '/'
    click_on('Notre Dame Patents')
    catalog_page = Curate::Pages::CatalogPage.new(category: :patents)
    expect(catalog_page).to be_on_page
  end

  scenario 'Press', :read_only do
    visit '/'
    click_on('Notre Dame Press')
    catalog_page = Curate::Pages::CatalogPage.new(category: :press)
    expect(catalog_page).to be_on_page
  end

  scenario 'Thesis & Dissertations', :read_only do
    visit '/'
    click_on('Graduate School Theses & Dissertations')
    catalog_page = Curate::Pages::CatalogPage.new(category: :thesis)
    expect(catalog_page).to be_on_page
  end

  scenario 'Varieties of Democracy', :read_only do
    visit '/'
    click_on('Varieties of Democracy')
    catalog_page = Curate::Pages::CatalogPage.new(category: :varieties)
    expect(catalog_page).to be_on_page
  end
end

feature 'Catalog Thumbnail Views:', js: true do
  scenario 'List vs. Grid View of Types of Work', :read_only do
    visit '/'
    click_on('All Items')
    within('.facets') do
      find("a[data-target='#collapse_Type_of_Work']").click
    end
    within('#collapse_Type_of_Work.accordion-body.in.collapse') do
      find_link('Show more').trigger('click')
    end
    category_page = Curate::Pages::CatalogPage.new()
    category_page.test_facets_list_vs_grid
  end
end

feature 'Browsing attached files' do
  scenario "Show an Article with many files", :read_only, :nonprod_only do
    visit '/'
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
    search_term = "Article with many files"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new(search_term: search_term)
    expect(catalog_page).to be_on_page
    article_link = first('a[id^="src_copy_link"]')
    show_article = Curate::Pages::ShowArticlePage.new(title: article_link.text)
    article_link.click

    # Check the state of the rendered page
    expect(show_article).to be_on_page
    expect(show_article).to have_files
    expect(show_article).to have_pagination("files_page")

    # Check that a user can download one of the files
    download_link=find("article.attached-file a", match: :first)
    file_name=download_link.text
    download_link_href = download_link['href']
    download_link.click
    last_opened_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(last_opened_window)
    # Can't check the page url, get "about:blank". Have to check that the response header has the right file name.
    # Doing it this way also tests that the download link (not the button) has the file name as the text for the link
    expect(page.response_headers['Content-Disposition']).to match(/filename="#{file_name}"/)
    expect(status_code.to_s).to match(/^20[0,1,6]$/)
  end
end
