# frozen_string_literal: true
require 'dave/dave_spec_helper'
SITE_URL = "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/0"

feature 'View DAVE Artifact', js: true do
  scenario 'Load First Document' do
    visitHome() 
  end

  scenario 'Select Next Image' do
    visitHome()
    visitNewPage(1)
    expect(page.current_url).to eq(SITE_URL.split("/").first(7).join("/")+"/1")
  end

  scenario 'Select Previous Image' do
    visitHome()
    visitNewPage(1)
    expect(page.current_url).to eq(SITE_URL.split("/").first(7).join("/")+"/1")
    visitNewPage(2)
    expect(page.current_url).to eq(SITE_URL.split("/").first(7).join("/")+"/2")
    visitNewPage(1)
    expect(page.current_url).to eq(SITE_URL.split("/").first(7).join("/")+"/1")
  end
  scenario 'Select Last Image' do
    visitHome()
    last_page = getLastPage()
    visitNewPage(last_page)
    checkImageSelection(last_page)
  end

  scenario 'Select First Image' do
    visitHome()
    last_page = getLastPage()
    visitNewPage(last_page)
    checkImageSelection(last_page)
    visitNewPage(0)
    checkImageSelection(0)
  end
  scenario 'Select Specific Page' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    within('.Drawer__wrapper___d9kg1') do
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
    visitHome()
    twoPageViewURL = generateViewURL("2/0")
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find("a[href='#{twoPageViewURL}']").click
    end
    twoPageViewURL=SITE_URL.split("/").first(6).join("/")+"/2/0"
    expect(page.current_url).to eq(twoPageViewURL)
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page-1)
    within("select") do
      select (pageNumber+1).to_s
    end
    dropdownValue = find('select').value.to_i
    expect(dropdownValue).to eq(pageNumber)
    url = twoPageViewURL.split("/").first(7).join("/")+"/"+pageNumber.to_s
    expect(page.current_url).to eq(url)
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_two_page
  end
  scenario 'Go to Grid Image View' do
    visitHome()
    grid_url=generateViewURL("g/0")
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find("a[href='#{grid_url}']").click
    end
    grid_url=SITE_URL.split("/").first(6).join("/")+"/g/0"
    expect(page.current_url).to eq(grid_url)
  end

  scenario 'Go to Detail View' do
    visitHome()
    last_page = getLastPage()
    pageNumber = Random.rand(1..last_page)
    grid_url = generateViewURL("g/0")
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find("a[href='#{grid_url}']").click
    end
    grid_url=SITE_URL.split("/").first(6).join("/")+"/g/0"
    expect(page.current_url).to eq(grid_url)
    grid_url = generateViewURL("g/"+pageNumber.to_s)
    detail_grid_url= grid_url+"/detail"
    within(".GridView__gridview___3RJhp") do
      find("a[href='#{detail_grid_url}']").trigger('click')
    end
    grid_url = SITE_URL.split("/").first(6).join("/")+"/g/" + pageNumber.to_s
    grid_url=grid_url+"/detail"
    expect(page.current_url).to eq(grid_url)
    first_doc = Dave::Pages::FirstDocument.new
    using_wait_time 50 do
      expect(first_doc).to be_detail_view
    end
  end
end

def visitHome
  visit SITE_URL
  first_doc = Dave::Pages::FirstDocument.new
  expect(first_doc).to be_on_page
end

def generateViewURL(viewString)
  url = SITE_URL.split("/").last(5).first(3).join('/')+"/"+viewString
  return "/"+url
end

def checkImageSelection(imageNumber)
  url = SITE_URL[0..-2]+imageNumber.to_s
  expect(page.current_url).to eq(url)
  dropdownValue = find('select').value.to_i
  expect(dropdownValue).to eq(imageNumber)
end

def visitNewPage(pageNumber)
  url = SITE_URL.split("/").last(5).first(4).join('/')
  url = "/"+url+'/'+pageNumber.to_s
  within('.DigitalArtifact__bottomBar___2iYjT') do
    find("a[href='#{url}']").click
  end
end

def getLastPage
  last_page = 0
  within("select") do
    last_page = all('option')[-1].text.to_i - 1
  end
  return last_page
end
