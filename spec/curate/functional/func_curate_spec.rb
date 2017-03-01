# frozen_string_literal: true
require 'curate/curate_spec_helper'

feature 'User Browsing', js: true do
  scenario 'Load Homepage' do
    visit '/'
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_page
  end

  scenario 'Go to About page' do
    visit '/'
    click_on('About')
    about_page = Curate::Pages::AboutPage.new
    expect(about_page).to be_on_page
  end

  scenario 'Go to FAQ page' do
    visit '/'
    click_on('FAQ')
    faq_page = Curate::Pages::FaqPage.new
    expect(faq_page).to be_on_page
  end

  scenario 'Go to catalog search page with empty search term' do
    visit '/'
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new({})
    expect(catalog_page).to be_on_page
  end

  scenario 'Go to catalog search page with term "Article"' do
    visit '/'
    search_term = "Article"
    fill_in('catalog_search', with: search_term)
    click_on('Search')
    catalog_page = Curate::Pages::CatalogPage.new(search_term: search_term)
    expect(catalog_page).to be_on_page
    click_on('Clear all')
    expect(catalog_page).to be_on_base_url
  end

  scenario 'Category search for Theses' do
    visit '/'
    title = 'Theses & Dissertations'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :thesis)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Category search for Articles' do
    visit '/'
    title = 'Articles & Publications'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :article)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Category search for Datasets' do
    visit '/'
    title = 'Datasets & Related Materials'
    click_on(title)
    category_page = Curate::Pages::CatalogPage.new(category: :dataset)
    expect(category_page).to be_on_page
    click_on('Clear all')
    expect(category_page).to be_on_base_url
  end

  scenario 'Contribute Your Work' do
    visit '/'
    click_on('Contribute Your Work')
    contribute_page = Curate::Pages::ContributePage.new
    expect(contribute_page).to be_on_page
  end

  scenario 'Materials by Department link' do
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
    article_link = download_button['href'].split('/').last(2)
    download_button.click
    page.driver.browser.switch_to_window(page.driver.browser.window_handles.last)
    expect(page.current_url).to eq(File.join(Capybara.app_host, article_link))
    expect(status_code).to eq(200 || 201 || 206)
  end
end

feature 'Requesting Help', js: true do
  scenario 'Go to help page' do
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
  scenario "modal facets" do
    visit '/'
    click_on('Search')
    ['Department or Unit', 'Collection'].shuffle.each do |facet_name|
      current_logger.info(context: "Processing Facet: #{facet_name}")
      expect(page).not_to have_selector("#ajax-modal")
      click_on(facet_name)
      expect(page).to have_selector('#ajax-modal', visible: true)
      expect(page).to have_content(facet_name)
      within('#ajax-modal') do
        find('.close').click
      end
      expect(page).not_to have_selector("#ajax-modal", visible: true)
    end
  end

  scenario 'non-modal Facets' do
    visit '/'
    click_on('Search')
    ['Type_of_Work', 'Creator', 'Subject', 'Language', 'Publisher', 'Academic_Status'].shuffle.each do |facet_name|
      sleep(0.3) # Included because the JS expand behavior was not always completing before the driver said it was ready
      current_logger.info(context: "Processing Facet: #{facet_name}")
      expect(page).not_to have_css("ul.facets #collapse_#{facet_name}.in")
      find("ul.facets a[data-target=\"#collapse_#{facet_name}\"]").click
      expect(page).to have_css("ul.facets #collapse_#{facet_name}.in .slide-list")
    end
  end
end

feature 'Logged In User Browsing', js: true do
  let(:user) {Curate::Pages::LoginPage.new}
  scenario "Log in" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
  end

  scenario "Manage My Works" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    click_on("My Works")
    sleep(3)
    works_page = Curate::Pages::WorksPage.new
    expect(works_page).to be_on_page
  end

  scenario "Visit Manage My Groups page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    click_on("My Groups")
    sleep(3)
    groups_page = Curate::Pages::GroupsPage.new
    expect(groups_page).to be_on_page
  end

  scenario "Visit Manage My Collections page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    click_on("My Collections")
    sleep(3)
    collections_page = Curate::Pages::CollectionsPage.new
    expect(collections_page).to be_on_page
  end

  scenario "Visit Manage My Profile page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    click_on("My Profile")
    sleep(3)
    profile_page = Curate::Pages::ProfilePage.new
    expect(profile_page).to be_on_page
  end

  scenario "Visit Manage My Delegates page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    click_on("My Delegates")
    sleep(3)
    delegates_page = Curate::Pages::DelegatesPage.new
    expect(delegates_page).to be_on_page
  end

  scenario "Visit Deposit New Article page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("New Article")
    sleep(3)
    article_page = Curate::Pages::ArticlePage.new
    expect(article_page).to be_on_page
  end

  scenario "Visit Deposit New Dataset page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("New Dataset")
    sleep(3)
    dataset_page = Curate::Pages::DatasetPage.new
    expect(dataset_page).to be_on_page
  end

  scenario "Visit Deposit New Document page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("New Document")
    sleep(3)
    document_page = Curate::Pages::DocumentPage.new
    expect(document_page).to be_on_page
  end

  scenario "Visit Deposit New Image page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("New Image")
    sleep(3)
    image_page = Curate::Pages::ImagePage.new
    expect(image_page).to be_on_page
  end

  scenario "Visit More Options page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("More Options")
    sleep(3)
    options_page = Curate::Pages::OptionsPage.new
    expect(options_page).to be_on_page
  end

  scenario "Visit Deposit New Audio page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("More Options")
    sleep(3)
    options_page = Curate::Pages::OptionsPage.new
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_audio').click
    sleep(2)
    audio_page = Curate::Pages::AudioPage.new
    expect(audio_page).to be_on_page
  end

  scenario "Visit Deposit New Senior Thesis page" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.add-content").click
    click_on("More Options")
    sleep(3)
    options_page = Curate::Pages::OptionsPage.new
    expect(options_page).to be_on_page
    find('.add-button.btn.btn-primary.add_new_senior_thesis').click
    sleep(2)
    thesis_page = Curate::Pages::ThesisPage.new
    expect(thesis_page).to be_on_page
  end

  scenario "Log out" do
    user.completeLogin
    home_page = Curate::Pages::HomePage.new
    expect(home_page).to be_on_logged_in_page
    find("div.btn-group.my-actions").click
    click_on("Log Out")
    user.checkLoginPage
  end
end
