# frozen_string_literal: true

require 'dave/dave_spec_helper'

class DaveSite
  # This class manages the various parts of the Dave Site url for the test
  # cases. It initializes the url for a given document id and handles all
  # changes in the url resulting from site navigation.
  include Capybara::DSL
  include CapybaraErrorIntel::DSL
  DEFAULT_DOCUMENT_SLUG = 'MSN-COL_9101'
  DEFUALT_SITE_URL = "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com"
  attr_accessor :document_slug
  attr_reader :site_url
  # Any document may have multiple sources the site can pull from
  # this attribute specifies which source the user is currently viewing.
  attr_accessor :document_source
  # Each document may have different sequences which may contain different
  # parts of the document such as a sequence of only the images in the document
  # this attribute determines which sequence the user is viewing.
  attr_accessor :document_sequence

  def initialize(document_slug: DEFAULT_DOCUMENT_SLUG, site_url: DEFUALT_SITE_URL, document_source: 0, document_sequence: 0)
    @document_slug = document_slug
    @site_url = site_url
    @document_source = document_source
    @document_sequence = document_sequence
  end

  def current_url_for_document
    File.join(site_url, document_source.to_s, document_slug, document_sequence.to_s)
  end

  VIEW_TYPES = {
    one_page: '1',
    two_page: '2',
    grid: 'g'
  }.freeze
  def current_url_for_view_type(view_type: :one_page, page: 0)
    view_type = VIEW_TYPES.fetch(view_type)
    File.join(current_url_for_document, view_type, page.to_s)
  end

  # Generates relative links used for buttons
  def button_link_url(view_type: :one_page, page: 0)
    view_type = VIEW_TYPES.fetch(view_type)
    File.join(document_source.to_s, document_slug, document_sequence.to_s, view_type, page.to_s)
  end

  def visit_from_current_document(page: 0)
    url = File.join(current_url_for_document, '1', page.to_s)
    visit url
  end
end

feature 'View DAVE Artifact', js: true do
  let(:site) { DaveSite.new }
  scenario 'Load First Document', :read_only do
    visit_home
  end

  scenario 'Select Next Image', :read_only do
    visit_home
    visit_new_page(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
  end

  scenario 'Select Previous Image', :read_only do
    visit_home
    visit_new_page(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
    visit_new_page(page: 2)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 2))
    visit_new_page(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
  end
  scenario 'Select Last Image', :read_only do
    visit_home
    last_page = find_last_page
    visit_new_page(page: last_page)
    check_image_selection(imageNumber: last_page)
  end

  scenario 'Select First Image', :read_only do
    visit_home
    last_page = find_last_page
    visit_new_page(page: last_page)
    check_image_selection(imageNumber: last_page)
    visit_new_page
    check_image_selection(imageNumber: 0)
  end
  scenario 'Select Specific Page', :read_only do
    visit_home
    last_page = find_last_page
    page_number = Random.rand(1..last_page)
    node = find('div[class^="Drawer__wrapper"]')
    within(node) do
      all("a")[page_number].trigger('click')
    end
    check_image_selection(imageNumber: page_number)
  end

  scenario 'Make a Dropdown Selection', :read_only do
    visit_home
    last_page = find_last_page
    page_number = Random.rand(1..last_page)
    within("select") do
      select(page_number + 1).to_s
    end
    check_image_selection(imageNumber: page_number)
  end
  scenario 'Go to Two Image View', :read_only do
    visit_home
    two_page_view_url = site.button_link_url(view_type: :two_page)
    within(bottom_document_navbar) do
      find("a[href='#{two_page_view_url}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :two_page))
    last_page = find_last_page
    page_number = Random.rand(1..last_page - 1)
    within("select") do
      select(page_number + 1).to_s
    end
    dropdown_value = find('select').value.to_i
    expect(dropdown_value).to eq(page_number)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :two_page, page: page_number))
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_two_page
  end
  scenario 'Go to Grid Image View', :read_only do
    visit_home
    grid_url = site.button_link_url(view_type: :grid)
    within(bottom_document_navbar) do
      find("a[href='#{grid_url}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :grid))
  end

  scenario 'Go to Detail View', :read_only do
    visit_home
    last_page = find_last_page
    page_number = Random.rand(1..last_page)
    grid_url = site.button_link_url(view_type: :grid)
    within(bottom_document_navbar) do
      find("a[href='#{grid_url}']").click
    end
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :grid))
    grid_url = site.button_link_url(view_type: :grid, page: page_number)
    detail_grid_url = grid_url + "/detail"
    grid_view = find('div[class^="grid_view__grid_view"]')
    within(grid_view) do
      find("a[href='#{detail_grid_url}']").trigger('click')
    end
    grid_url = site.current_url_for_view_type(view_type: :grid, page: page_number)
    grid_url += "/detail"
    expect(page.current_url).to eq(grid_url)
    first_doc = Dave::Pages::FirstDocument.new
    using_wait_time 50 do
      expect(first_doc).to be_detail_view
    end
  end
  scenario 'Visit Page from Current Document', :read_only do
    site.visit_from_current_document(page: 1)
    expect(page.current_url).to eq(site.current_url_for_view_type(view_type: :one_page, page: 1))
  end
end

def bottom_document_navbar
  find('div[class^="DigitalArtifact__bottomBar"]')
end

# Visit SITE_URL and check for navigation buttons
def visit_home
  visit site.current_url_for_view_type
  puts site.current_url_for_view_type
  first_doc = Dave::Pages::FirstDocument.new
  expect(first_doc).to be_on_page
end

# Click the link on the page pointing to the given page number.
def visit_new_page(page: 0)
  url = site.button_link_url(page: page)
  within(bottom_document_navbar) do
    find("a[href='#{url}']").click
  end
end

# Check that the value in the dropdown matches the current image as well as the URL
def check_image_selection(imageNumber: 0)
  expect(page.current_url).to eq(site.current_url_for_view_type(page: imageNumber))
  dropdown_value = find('select').value.to_i
  expect(dropdown_value).to eq(imageNumber)
end

# Find the last page in the document from the dropdown selector
def find_last_page
  last_page = 0
  within("select") do
    last_page = all('option')[-1].text.to_i - 1
  end
end
