# frozen_string_literal: true
# This class provides support to interact with the following contentful APIs:
# * Content Delivery API: https://www.contentful.com/developers/docs/references/content-delivery-api/
# * Content Management API: https://www.contentful.com/developers/docs/references/content-management-api/
# * Content Preview API: https://www.contentful.com/developers/docs/references/content-preview-api/
# * Images API: https://www.contentful.com/developers/docs/references/images-api/

class ContentfulHandler
  def initialize(for_file_path:, config:, current_logger:)
    @current_logger = current_logger
    example_variable = ExampleVariableExtractor.call(path: for_file_path, config: config)
    read_contentful_tokens
    create_entry
  end

  def read_contentful_tokens
    user_home_dir = File.expand_path('~')
    cf_key_file = YAML.load_file(File.join(user_home_dir.to_s, 'test_data/QA/cf_api_key.yml'))
    @space_id = cf_key_file.fetch('QA_key').fetch('space_id')
    @cdn_token = cf_key_file.fetch('QA_key').fetch('cdn_token')
    @preview_token = cf_key_file.fetch('QA_key').fetch('preview_token')
    @personal_access_token = cf_key_file.fetch('QA_key').fetch('personal_access_token')
  end

  def create_entry
    create_client
    content_type = @client.content_types.find(@space_id, 'page')
    @title_for_entry = 'Testing page ' + RunIdentifier.get
    @current_logger.info(context: "Creating page in contentful", page_title: @title_for_entry)
    @entry = @client.entries.create(content_type, title: @title_for_entry)
  end

  def create_client
    @client = Contentful::Management::Client.new(@personal_access_token)
  end

  def in_contentful?
    if @entry.title == @title_for_entry
      @current_logger.info(context: "Page created in contentful", page_title: @title_for_entry)
    end
  end
end
