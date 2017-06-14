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

  scenario 'Category search for Theses', :read_only do
    visit '/'
    title = 'Theses & Dissertations'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :thesis)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
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
    title = 'Datasets & Related Materials'
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

  scenario 'Materials by Department link', :read_only do
    visit '/'
    click_on('Materials by Department')
    dept_page = Curate::Pages::DepartmentsPage.new
    expect(dept_page).to be_on_page
    departmental_link = dept_page.select_random_departmental_link
    dept_search_page = Curate::Pages::CatalogPage.new(category: :department, departmental_link: departmental_link)
    visit departmental_link.link
    expect(dept_search_page).to be_on_page
  end

  scenario "Show an Article" do
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
    download_button=find("a.action.btn", :text => "Download")
    article_link = download_button['href']
    download_button.click
    last_opened_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to_window(last_opened_window)
    expect(page.current_url).to eq(article_link)
    expect(status_code.to_s).to match(/^20[0,1,6]$/)
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
      click_on(facet_name)
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

feature 'Logged In User (Account details NOT updated) Browsing', js: true do
  let(:login_page) { LoginPage.new(current_logger, account_details_updated: false) }
  scenario "Log in" do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
  end

  scenario "Manage My Works" do
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

  scenario "Visit Manage My Groups page" do
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

  scenario "Visit Manage My Collections page" do
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

  scenario "Visit Manage My Profile page" do
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

  scenario "Visit Deposit New Article page" do
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

  scenario "Visit Deposit New Dataset page" do
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

  scenario "Visit Deposit New Document page" do
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

  scenario "Visit Deposit New Image page" do
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

  scenario "Visit More Options page" do
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

  scenario "Visit Deposit New Audio page" do
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

  scenario "Visit Deposit New Senior Thesis page" do
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

  scenario "Log out" do
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
  scenario "Log in" do
    visit '/'
    click_on('Log In')
    login_page.completeLogin
    logged_in_home_page = Curate::Pages::LoggedInHomePage.new(login_page)
    expect(logged_in_home_page).to be_on_page
  end

  scenario "Manage My Works", js: true do
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

  scenario "Visit Manage My Groups page" do
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

  scenario "Visit Manage My Collections page" do
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

  scenario "Visit Manage My Profile page" do
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

  scenario "Visit Manage My Delegates page" do
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

  scenario "Visit Deposit New Article page" do
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

  scenario "Visit Deposit New Dataset page" do
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

  scenario "Visit Deposit New Document page" do
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

  scenario "Visit Deposit New Image page" do
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

  scenario "Visit More Options page" do
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

  scenario "Visit Deposit New Audio page" do
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

  scenario "Visit Deposit New Senior Thesis page" do
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
