require 'airborne'
require 'rspec'

describe 'Step 1: Collections endpoint' do
  it 'returns a response' do
    get 'https://honeycombpprd-vm.library.nd.edu/v1/collections'

    #headers comes back as a rspec hash, use expect validations using include matchers
    #https://www.relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/include-matcher#hash-usage
    expect(headers).to include(:status => '200 OK')
    expect(body).not_to be_empty
  end
end

describe 'Step 2: Collections endpoint' do
  it 'validates JSON schema' do
    get 'https://honeycombpprd-vm.library.nd.edu/v1/collections'

    expect(json_body).to match_array([:name_line_1, :name_line_2, :items, :unique_id, :showcases,
   :collection_users, :published, :preview_mode, :users, :updated_at, :created_at,
   :short_intro, :showcases, :hide_title_on_home_page, :about, :copyright,
   :enable_search, :enable_browse, :image, :url_slug, :pages, :collection_configuration])
  end
end
