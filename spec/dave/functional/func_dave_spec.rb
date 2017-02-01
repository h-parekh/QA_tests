require 'dave/dave_spec_helper'
SITE_URL = "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/0"
feature 'DAVE artifact viewing', js: true do
  scenario 'Load 1st example' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
  end

  scenario 'Next Image' do
    visit '/0/MSN-COL_9101-1-B/0/1/0'
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/1"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/1')
  end
  scenario 'Previous Image' do
    visit '/0/MSN-COL_9101-1-B/0/1/0'
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/1"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/1')
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/2"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/2')
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/1"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/1')
  end
  scenario 'Last Image' do
    visit '/0/MSN-COL_9101-1-B/0/1/0'
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/269"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/269')
    val = find('select').value
    expect(val).to eq("269")
  end
  scenario 'First Image' do
    visit '/0/MSN-COL_9101-1-B/0/1/0'
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/269"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/269')
    val = find('select').value
    expect(val).to eq("269")
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find('a[href="/0/MSN-COL_9101-1-B/0/1/0"]').click
    end
    expect(page.current_url).to eq('http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/0')
    val = find('select').value
    expect(val).to eq("0")
  end
  scenario 'Specific Page Selection' do
    visit '/0/MSN-COL_9101-1-B/0/1/0'
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.Drawer__wrapper___d9kg1') do
      pg = Random.rand(1..269)
      link = "a[href='/0/MSN-COL_9101-1-B/0/1/#{pg.to_s}']"
      puts link
      find("a[href='/0/MSN-COL_9101-1-B/0/1/2']").click
    end
    val = find('select').value.to_i
    expect(val).to eq(pg)
  end
end
