# frozen_string_literal: true
require 'dave/dave_spec_helper'
SITE_URL = "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/0"

class DaveSite
  attr_accessor :document_slug

  def initialize(document_slug: '/0/MSN-COL_9101-1-B/0/') # Initializes the document being viewed
    @document_slug = document_slug
  end

  def site_url # Base url for DAVE test site
    "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com"
  end

  def current_url_for_document
    File.join(site_url, document_slug)
  end

  VIEW_TYPES = {
    one_page: '1',
    two_page: '2',
    grid: 'g'
  }
  def current_url_for_view_type(type: :one_page, page: '0')
    view_type = VIEW_TYPES.fetch(type)
    File.join(current_url_for_document, view_type, page)
  end

  def button_link_url(type: :one_page, page: '0') # Generates relative links used for buttons
    view_type = VIEW_TYPES.fetch(type)
    File.join(document_slug,view_type,'/',page)
  end
end

feature 'View DAVE Artifact', js: true do
  scenario 'Load First Document' do
    visitHome()
  end

  scenario 'Select Next Image' do
    site = DaveSite.new
    visitHome()
    visitNewPage(site,'1')
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :one_page, page: '1'))
  end

  scenario 'Select Previous Image' do
    site = DaveSite.new
    visitHome()
    visitNewPage(site, '1')
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :one_page, page: '1'))
    visitNewPage(site, '2')
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :one_page, page: '2'))
    visitNewPage(site, '1')
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :one_page, page: '1'))
  end
  scenario 'Select Last Image' do
    site = DaveSite.new
    visitHome()
    last_page = getLastPage()
    visitNewPage(site,last_page.to_s)
    checkImageSelection(last_page)
  end

  scenario 'Select First Image' do
    site = DaveSite.new
    visitHome()
    last_page = getLastPage()
    visitNewPage(site,last_page.to_s)
    checkImageSelection(last_page)
    visitNewPage(site, '0')
    checkImageSelection(0)
  end
  scenario 'Select Specific Page' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    node  = find('div[class^="Drawer__wrapper"]')
    within(node) do
      all("a")[pageNumber].trigger('click')
    end
    checkImageSelection(pageNumber)
  end

  scenario 'Make a Dropdown Selection' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    within("select") do
      select (pageNumber+1).to_s
    end
    checkImageSelection(pageNumber)
  end
  scenario 'Go to Two Image View' do
    site = DaveSite.new
    visitHome()
    twoPageViewURL = site.button_link_url(type: :two_page)
    bottomBar = find('div[class^="DigitalArtifact__bottomBar"]')
    within(bottomBar) do
      find("a[href='#{twoPageViewURL}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :two_page))
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page-1)
    within("select") do
      select (pageNumber+1).to_s
    end
    dropdownValue = find('select').value.to_i
    expect(dropdownValue).to eq(pageNumber)
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :two_page, page: pageNumber.to_s))
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_two_page
  end
  scenario 'Go to Grid Image View' do
    site = DaveSite.new
    visitHome()
    gridURL = site.button_link_url(type: :grid)
    bottomBar = find('div[class^="DigitalArtifact__bottomBar"]')
    within(bottomBar) do
      find("a[href='#{gridURL}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :grid))
  end

  scenario 'Go to Detail View' do
    site = DaveSite.new
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    gridURL=site.button_link_url(type: :grid)
    bottomBar = find('div[class^="DigitalArtifact__bottomBar"]')
    within(bottomBar) do
      find("a[href='#{gridURL}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(type: :grid))
    gridURL = site.button_link_url(type: :grid, page: pageNumber.to_s)
    detail_grid_url= gridURL+"/detail"
    gridView = find('div[class^="GridView__gridview"]')
    within(gridView) do
      find("a[href='#{detail_grid_url}']").trigger('click')
    end
    gridURL = site.current_url_for_view_type(type: :grid, page: pageNumber.to_s)
    gridURL=gridURL+"/detail"
    expect(page.current_url).to eq(gridURL)
    first_doc = Dave::Pages::FirstDocument.new
    using_wait_time 50 do
      expect(first_doc).to be_detail_view
    end
  end
end

def visitHome # Visit SITE_URL and check for navigation buttons
  site = DaveSite.new
  visit site.current_url_for_view_type()
  first_doc = Dave::Pages::FirstDocument.new
  expect(first_doc).to be_on_page
end
def visitNewPage(site, page) # Click the link on the page pointing to the given page number.
  url = site.button_link_url(page: page)
  bottomBar = find('div[class^="DigitalArtifact__bottomBar"]')
  within(bottomBar) do
    find("a[href='#{url}']").click
  end
end
def checkImageSelection(imageNumber) # Check that the value in the dropdown matches the current image as well as the URL
  site = DaveSite.new
  expect(page.current_url).to eq(site.current_url_for_view_type(page: imageNumber.to_s))
  dropdownValue = find('select').value.to_i
  expect(dropdownValue).to eq(imageNumber)
end

def getLastPage #Find the last page in the document from the dropdown selector
  last_page = 0
  within("select") do
    last_page = all('option')[-1].text.to_i - 1
  end
  return last_page
end
