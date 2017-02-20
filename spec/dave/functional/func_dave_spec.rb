# frozen_string_literal: true
require 'dave/dave_spec_helper'

class DaveSite
  include Capybara::DSL
  include CapybaraErrorIntel::DSL
  attr_accessor :document_slug
  attr_accessor :site_url
  attr_accessor :doc_source
  attr_accessor :sequence

  def initialize(document_slug: 'MSN-COL_9101-1-B', site_url: "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com", doc_source: "/0/", sequence: "/0/") # Initializes the document being viewed
    @document_slug = document_slug
    @site_url = site_url
    @doc_source = doc_source
    @sequence = sequence
  end

  def current_url_for_document
    File.join(site_url, doc_source, document_slug, sequence)
  end

  VIEW_TYPES = {
    one_page: '1',
    two_page: '2',
    grid: 'g'
  }
  def current_url_for_view_type(view_type: :one_page, page: 0)
    view_type = VIEW_TYPES.fetch(view_type)
    File.join(current_url_for_document, view_type, page.to_s)
  end

  def button_link_url(view_type: :one_page, page: 0) # Generates relative links used for buttons
    view_type = VIEW_TYPES.fetch(view_type)
    File.join(doc_source, document_slug, sequence,view_type,'/',page.to_s)
  end

  def visit_from_current_document(page: 0)
    url = File.join(current_url_for_document, '1', page.to_s)
    visit url
  end
end

feature 'View DAVE Artifact', js: true do
  let(:site) { DaveSite.new }
  scenario 'Load First Document' do
    visitHome()
  end

  scenario 'Select Next Image' do
    visitHome()
    visitNewPage(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
  end

  scenario 'Select Previous Image' do
    visitHome()
    visitNewPage(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
    visitNewPage(page: 2)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 2))
    visitNewPage(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
  end
  scenario 'Select Last Image' do
    visitHome()
    last_page = getLastPage()
    visitNewPage(page: last_page)
    checkImageSelection(imageNumber: last_page)
  end

  scenario 'Select First Image' do
    visitHome()
    last_page = getLastPage()
    visitNewPage(page: last_page)
    checkImageSelection(imageNumber: last_page)
    visitNewPage()
    checkImageSelection(imageNumber: 0)
  end
  scenario 'Select Specific Page' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    node  = find('div[class^="Drawer__wrapper"]')
    within(node) do
      all("a")[pageNumber].trigger('click')
    end
    checkImageSelection(imageNumber: pageNumber)
  end

  scenario 'Make a Dropdown Selection' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    within("select") do
      select (pageNumber+1).to_s
    end
    checkImageSelection(imageNumber: pageNumber)
  end
  scenario 'Go to Two Image View' do
    visitHome()
    twoPageViewURL = site.button_link_url(view_type: :two_page)
    within(bottom_Document_NavBar) do
      find("a[href='#{twoPageViewURL}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :two_page))
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page-1)
    within("select") do
      select (pageNumber+1).to_s
    end
    dropdownValue = find('select').value.to_i
    expect(dropdownValue).to eq(pageNumber)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :two_page, page: pageNumber))
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_two_page
  end
  scenario 'Go to Grid Image View' do
    visitHome()
    gridURL = site.button_link_url(view_type: :grid)
    within(bottom_Document_NavBar) do
      find("a[href='#{gridURL}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :grid))
  end

  scenario 'Go to Detail View' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    gridURL=site.button_link_url(view_type: :grid)
    within(bottom_Document_NavBar) do
      find("a[href='#{gridURL}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :grid))
    gridURL = site.button_link_url(view_type: :grid, page: pageNumber)
    detail_grid_url= gridURL+"/detail"
    gridView = find('div[class^="GridView__gridview"]')
    within(gridView) do
      find("a[href='#{detail_grid_url}']").trigger('click')
    end
    gridURL = site.current_url_for_view_type(view_type: :grid, page: pageNumber)
    gridURL=gridURL+"/detail"
    expect(page.current_url).to eq(gridURL)
    first_doc = Dave::Pages::FirstDocument.new
    using_wait_time 50 do
      expect(first_doc).to be_detail_view
    end
  end
  scenario 'Visit Page from Current Document' do
    site.visit_from_current_document(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
  end
end

def bottom_Document_NavBar
  find('div[class^="DigitalArtifact__bottomBar"]')
end
def visitHome # Visit SITE_URL and check for navigation buttons
  visit site.current_url_for_view_type()
  first_doc = Dave::Pages::FirstDocument.new
  expect(first_doc).to be_on_page
end
def visitNewPage(page: 0) # Click the link on the page pointing to the given page number.
  url = site.button_link_url(page: page)
  within(bottom_Document_NavBar) do
    find("a[href='#{url}']").click
  end
end
def checkImageSelection(imageNumber: 0) # Check that the value in the dropdown matches the current image as well as the URL
  expect(page.current_url).to eq(site.current_url_for_view_type(page: imageNumber))
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
