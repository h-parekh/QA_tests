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
        find('.close').click
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
      find("ul.facets a[data-target=\"#collapse_#{facet_name}\"]").click
      expect(page).to have_css("ul.facets #collapse_#{facet_name}.in .slide-list")
    end
  end
end

feature 'Logged In User (Account details NOT updated)', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }

  scenario "Clicks each menu item under 'Manage' and 'Deposit'", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    # Validate 'My works' page works
    logged_in_home_page.open_actions_drawer
    click_on("My Works")
    works_page = Curate::Pages::MyWorksPage.new
    expect(works_page).to be_on_page
    # Validate 'Group Administration' page works
    logged_in_home_page.open_actions_drawer
    click_on("Group Administration")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    # Validate 'My Account' page works
    logged_in_home_page.open_actions_drawer
    click_on("My Account")
    my_account_page = Curate::Pages::MyAccountPage.new
    expect(my_account_page).to be_on_page
    # Validate 'New Article' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Article")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    # Validate 'New Dataset' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Dataset")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    # Validate 'New Document' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Document")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    # Validate 'New Image' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Image")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    # Validate 'More Options' page works
    logged_in_home_page.open_add_content_drawer
    click_on("More Options")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    # Tests log out button works
    logged_in_home_page.open_actions_drawer
    click_on("Log Out")
    login_page.check_login_page
  end
end

feature 'Logged In User (Account details updated) Browsing', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: true) }

  scenario "Clicks each menu item under 'Manage' and 'Deposit", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    # Validate 'My Works' page works
    logged_in_home_page.open_actions_drawer
    click_on("My Works")
    works_page = Curate::Pages::MyWorksPage.new
    expect(works_page).to be_on_page
    # Validate 'Group Administration' page works
    logged_in_home_page.open_actions_drawer
    click_on("Group Administration")
    groups_page = Curate::Pages::MyGroupsPage.new
    expect(groups_page).to be_on_page
    # Validate 'My Account' page works
    logged_in_home_page.open_actions_drawer
    click_on("My Account")
    account_page = Curate::Pages::MyAccountPage.new
    expect(account_page).to be_on_page
    # Validate 'New Article' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Article")
    article_page = Curate::Pages::ArticlePage.new
    expect(article_page).to be_on_page
    # Validate 'New Dataset' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Dataset")
    dataset_page = Curate::Pages::DatasetPage.new
    expect(dataset_page).to be_on_page
    # Validate 'New Document' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Document")
    document_page = Curate::Pages::DocumentPage.new
    expect(document_page).to be_on_page
    # Validate 'New Image' page works
    logged_in_home_page.open_add_content_drawer
    click_on("New Image")
    image_page = Curate::Pages::ImagePage.new
    expect(image_page).to be_on_page
    # Validate 'More Options' page works
    logged_in_home_page.open_add_content_drawer
    click_on("More Options")
    options_page = Curate::Pages::StartDepositPage.new
    expect(options_page).to be_on_page
    # Validate 'New Audio' page works
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_audio').click
    audio_page = Curate::Pages::AudioPage.new
    expect(audio_page).to be_on_page
    # Validate 'Thesis' page works
    logged_in_home_page.open_add_content_drawer
    click_on("More Options")
    options_page = Curate::Pages::StartDepositPage.new
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_senior_thesis').click
    thesis_page = Curate::Pages::ThesisPage.new
    expect(thesis_page).to be_on_page
    # Validate 'Logout' page works
    logged_in_home_page.open_actions_drawer
    click_on("Log Out")
    login_page.check_login_page
  end
end

feature 'Embargo scenarios:', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: true) }

  scenario "Create Embargo Work", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.open_add_content_drawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    # To test if the ebargo date requirement works
    image_page.create_temp_image(access_rights: 'embargo', embargo_date: false)
    # Since there is no embargo date the url should not change
    expect(current_url).to include('concern/images/new')
    fill_in(id: 'image_embargo_release_date', with: Date.today + 2)
    find('.btn.btn-primary.require-contributor-agreement').click
    expect(page).to have_css('.label.label-warning', text: "Under Embargo")
    expect(current_url).not_to include('concern/images/new')
  end

  scenario "Changing Work Access Rights to Embargo without Filling in Date Should Not Work", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.open_add_content_drawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    image_page.create_temp_image(access_rights: 'restricted')
    expect(page).to have_css('.main-header', text: "foo") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.page-actions') do
      click_on('Edit')
    end
    within('#set-access-controls') do
      choose(id: 'visibility_embargo')
    end
    # To test that the embargo date requirement works
    find('.btn.btn-primary.require-contributor-agreement').click
    expect(current_url).not_to include('confirm')
    fill_in(id: 'image_embargo_release_date', with: Date.today + 2)
    find('.btn.btn-primary.require-contributor-agreement').click
    expect(page).to have_css('.span12', text: "You've changed this foo to be open_with_embargo_release_date") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.button_to') do
      find('.btn.btn-primary').click
    end
    expect(page).to have_css('.label.label-warning', text: "Under Embargo")
  end

  scenario "Changing Work Access Rights from Embargo to Open", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.open_add_content_drawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    image_page.create_temp_image(access_rights: 'embargo')
    expect(page).to have_css('.main-header', text: "foo") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.page-actions') do
      click_on('Edit')
    end
    within('#set-access-controls') do
      choose(id: 'visibility_open')
    end
    find('.btn.btn-primary.require-contributor-agreement').click
    expect(page).to have_css('.span12', text: "You've changed this foo to be open.") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.button_to') do
      find('.btn.btn-primary').click
    end
    # Make sure the Access Control switches to Open
    expect(page).to have_css('.label.label-success', text: "Public")
  end

  scenario "Changing Work Access Rights from Registered to Embargo", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.open_add_content_drawer
    click_on('New Image')
    image_page = Curate::Pages::ImagePage.new
    image_page.create_temp_image(access_rights: 'ndu')
    expect(page).to have_css('.main-header', text: "foo") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.page-actions') do
      click_on('Edit')
    end
    within('#set-access-controls') do
      choose(id: 'visibility_embargo')
    end
    fill_in(id: 'image_embargo_release_date', with: Date.today + 2)
    find('.btn.btn-primary.require-contributor-agreement').click
    expect(page).to have_css('.span12', text: "You've changed this foo to be open_with_embargo_release_date") # Leveraging Capybara::Maleficent.with_sleep_injection
    within('.button_to') do
      find('.btn.btn-primary').click
    end
    expect(page).to have_css('.label.label-warning', text: "Under Embargo")
  end
end

feature 'Logged in user changing ORCID settings (Any account):', js: true do
  let(:login_page) { LoginPage.new(current_logger) }

  scenario "Go to ORCID.org registration page", :validates_login, :read_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.open_actions_drawer
    click_on("My Account")
    click_on("Update Personal Information")
    account_details_page = Curate::Pages::AccountDetailsPage.new
    expect(account_details_page).to be_on_page
    find_link('ORCID Settings').click
    sleep(1)
    orcid_settings_page = Curate::Pages::OrcidSettingsPage.new
    expect(orcid_settings_page).to be_on_page
    find_link('Create or Connect your ORCID iD').click
    sleep(1)
    orcid_home_page = Curate::Pages::OrcidHomePage.new
    expect(orcid_home_page).to be_on_page
  end
end

feature 'Featured Collections:', js: true do
  featured_collections = {
    patents: 'Notre Dame Patents',
    press: 'Notre Dame Press',
    thesis: 'Graduate School Theses & Dissertations',
    varieties: 'Varieties of Democracy'
  }
  scenario 'View each', :read_only do
    visit '/'
    featured_collections.each do |key, value|
      click_on(value.to_s)
      catalog_page = Curate::Pages::CatalogPage.new(category: key)
      expect(catalog_page).to be_on_page
      page.go_back
    end
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
      find_link('Show more').click
    end
    category_page = Curate::Pages::CatalogPage.new
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
    within('#attached-files') do
      find('table.table-striped.related-files').find('td.actions', match: :first).find('a.action.btn').click
    end
  end
end

feature 'Digital Object Identifiers:', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: true) }

  scenario "Logged in user can create a DOI for a new image", :nonprod_only do
    visit '/'
    click_on('Log In')
    login_page.complete_login
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
    logged_in_home_page.open_add_content_drawer
    click_on("New Image")
    image_page = Curate::Pages::ImagePage.new
    expect(image_page).to be_on_page
    image_page.create_temp_image(access_rights: 'ndu', assign_doi: 'mint-doi')
    show_article = Curate::Pages::ShowArticlePage.new(title: 'foo')
    expect(show_article).to be_new_doi_minted_article
    # Giving some wait time for the server to mint DOI
    sleep(3)
    page.refresh
    expect(show_article).to have_doi
    find_link('Edit').click
    edit_article = Curate::Pages::EditWorkPage.new
    expect(edit_article).to be_on_page
    expect(edit_article).to have_editable_doi
    find('.btn.btn-primary.require-contributor-agreement').click
  end

  scenario "Links to the DOI handler will redirect correctly back to the item", :read_only, :prod_only do
    visit '/'
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
    # This search term returns results for items with ND generated DOIs.
    # DOIs created from other publishers will not redirect back to the item
    search_term = "desc_metadata__identifier_tesim:doi:10.7274/r0"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    item_links = all('a[id^="src_copy_link"]')
    # This will test a small subset of items on the first page of search results to ensure
    # their dois correctly redirect
    item_urls = item_links[0...3].map { |item_link| item_link['href'] }
    item_urls.each do |item_url|
      visit item_url
      find_link('doi:').click
      expect(current_url).to eq(item_url)
    end
  end
end
