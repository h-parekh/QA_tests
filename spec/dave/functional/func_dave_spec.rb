require 'dave/dave_spec_helper'

SITE_URL = "http://testlibnd-dave.s3-website-us-east-1.amazonaws.com/0/MSN-COL_9101-1-B/0/1/0"
feature 'DAVE artifact viewing', js: true do
  scenario 'Load 1st example' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
  end

  scenario 'Next Image' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.DigitalArtifact__bottomBar___2iYjT') do
      url = SITE_URL[56..-2]+"1"
      find("a[href='#{url}']").click
    end
    expect(page.current_url).to eq(SITE_URL[0..-2]+"1")
  end
  scenario 'Previous Image' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    within('.DigitalArtifact__bottomBar___2iYjT') do
      url = SITE_URL[56..-2]+"1"
      find("a[href='#{url}']").click
    end
    expect(page.current_url).to eq(SITE_URL[0..-2]+"1")

    within('.DigitalArtifact__bottomBar___2iYjT') do
      url = SITE_URL[56..-2]+"2"
      find("a[href='#{url}']").click
    end
    expect(page.current_url).to eq(SITE_URL[0..-2]+"2")
  end
  scenario 'Last Image' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    last_pg = 0
    within("select") do
      last_pg = all('option')[-1].text.to_i - 1
    end
    within('.DigitalArtifact__bottomBar___2iYjT') do
      url = SITE_URL[56..-2]+last_pg.to_s
      find("a[href='#{url}']").click
    end
    url = SITE_URL[0..-2]+last_pg.to_s
    expect(page.current_url).to eq(url)
    val = find('select').value.to_i
    expect(val).to eq(last_pg)
  end
  scenario 'First Image' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    last_pg = 0
    within("select") do
      last_pg = all('option')[-1].text.to_i - 1
    end
    within('.DigitalArtifact__bottomBar___2iYjT') do
      url = SITE_URL[56..-2]+last_pg.to_s
      find("a[href='#{url}']").click
    end
    url = SITE_URL[0..-2]+last_pg.to_s
    expect(page.current_url).to eq(url)
    val = find('select').value.to_i
    expect(val).to eq(last_pg)
    within('.DigitalArtifact__bottomBar___2iYjT') do
      url = SITE_URL[56..-2]+"0"
      find("a[href='#{url}']").click
    end
    url = SITE_URL[0..-2]+"0"
    expect(page.current_url).to eq(url)
    val = find('select').value
    expect(val).to eq("0")
  end
  scenario 'Specific Page Selection' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    last_pg = 0
    within("select") do
      last_pg = all('option')[-1].text.to_i - 1
    end
    pg = Random.rand(1..last_pg)
    within('.Drawer__wrapper___d9kg1') do
      all("a")[pg].trigger('click')
    end
    url = SITE_URL[0..-2]+pg.to_s

    expect(page.current_url).to eq(url)
  end
  scenario 'Dropdown Selection' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    last_pg = 0
    within("select") do
      last_pg = all('option')[-1].text.to_i - 1
    end
    pg = Random.rand(1..last_pg)
    within("select") do
      select (pg+1).to_s
    end
    val = find('select').value.to_i
    expect(val).to eq(pg)
    url = SITE_URL[0..-2]+pg.to_s
    expect(page.current_url).to eq(url)
  end
  scenario 'Two Images' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    two_url = SITE_URL[56..-4]+"2/0"
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find("a[href='#{two_url}']").click
    end
    two_url=SITE_URL[0..-4]+"2/0"
    expect(page.current_url).to eq(two_url)
    last_pg = 0
    within("select") do
      last_pg = all('option')[-1].text.to_i - 1
    end
    pg = Random.rand(1..last_pg-1)
    within("select") do
      select (pg+1).to_s
    end
    val = find('select').value.to_i
    expect(val).to eq(pg)
    url = two_url[0..-2]+pg.to_s
    expect(page.current_url).to eq(url)
    expect(first_doc).to be_two_page
  end
  scenario 'Grid Images' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    grid_url = SITE_URL[56..-4]+"g/0"
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find("a[href='#{grid_url}']").click
    end
    grid_url=SITE_URL[0..-4]+"g/0"
    expect(page.current_url).to eq(grid_url)
  end
  scenario 'Detail View' do
    visit SITE_URL
    first_doc = Dave::Pages::FirstDocument.new
    expect(first_doc).to be_on_page
    last_pg = 0
    within("select") do
      last_pg = all('option')[-1].text.to_i - 1
    end
    pg = Random.rand(1..last_pg)
    grid_url = SITE_URL[56..-4]+"g/0"
    within('.DigitalArtifact__bottomBar___2iYjT') do
      find("a[href='#{grid_url}']").click
    end
    grid_url=SITE_URL[0..-4]+"g/0"
    expect(page.current_url).to eq(grid_url)
    grid_url = SITE_URL[56..-4]+"g/" + pg.to_s
    detail_grid_url= grid_url+"/detail"
    within(".GridView__gridview___3RJhp") do
      find("a[href='#{detail_grid_url}']").trigger('click')
    end
    grid_url = SITE_URL[0..-4]+"g/" + pg.to_s
    grid_url=grid_url+"/detail"
    expect(page.current_url).to eq(grid_url)
    using_wait_time 10 do
      expect(first_doc).to be_detail_view
    end
  end
end
