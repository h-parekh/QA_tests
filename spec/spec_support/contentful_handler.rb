# frozen_string_literal: true
# This class provides support to interact with the following contentful APIs:
# * Content Delivery API: https://www.contentful.com/developers/docs/references/content-delivery-api/
# * Content Management API: https://www.contentful.com/developers/docs/references/content-management-api/
# * Content Preview API: https://www.contentful.com/developers/docs/references/content-preview-api/
# * Images API: https://www.contentful.com/developers/docs/references/images-api/

class ContentfulHandler
  def self.create(for_file_path:, config:, current_logger:)
    handler = new(for_file_path: for_file_path, config: config, current_logger: current_logger)
    entry = handler.create_entry
    yield(entry)
  ensure
    begin
      entry.delete_entry
    rescue StandardError => e
      @current_logger.debug(context: "Failed to clean up entry. This may be okay, as it could have already been cleaned up. Exception: #{e.inspect}", page_title: entry.title_for_entry)
    end
  end

  # Prefer the .create method instead; It will ensure proper clean-up
  private_class_method :new

  attr_reader :slug_for_entry
  def initialize(for_file_path:, config:, current_logger:)
    @current_logger = current_logger
    read_contentful_tokens
    set_client!
  end

  def create_entry
    @content_type = @client.content_types.find(@space_id, 'page')
    @title_for_entry = 'Testing_page_' + RunIdentifier.get
    @slug_for_entry = @title_for_entry
    @current_logger.info(context: "Creating page in contentful", page_title: @title_for_entry)
    @entry = @client.entries.create(@content_type, title: @title_for_entry, slug: @slug_for_entry)
  end

  def in_contentful?
    if @entry.title == @title_for_entry
      @current_logger.info(context: "Page created in contentful", page_title: @title_for_entry)
    end
  end

  def make_entry_previewable
    @current_logger.info(context: "Making page previewable", page_title: @title_for_entry)
    preview_client = Contentful::Client.new(space: "#{@space_id}", access_token: "#{@preview_token}", api_url: 'preview.contentful.com')
    preview_client.entry("#{@entry.id}")
  end

  def delete_entry
    @current_logger.info(context: "Deleting page", page_title: @title_for_entry)
    @entry.destroy
  end

  def deleted?
    if @client.entries.find(@space_id, @entry.id).message == "The resource could not be found."
      @current_logger.info(context: "Page has been deleted", page_title: @title_for_entry)
    end
  end

  private

  def read_contentful_tokens
    cf_key_file = YAML.load_file(File.join(ENV.fetch('HOME'), 'test_data/QA/cf_api_key.yml'))
    @space_id = cf_key_file.fetch('QA_key').fetch('space_id')
    @cdn_token = cf_key_file.fetch('QA_key').fetch('cdn_token')
    @preview_token = cf_key_file.fetch('QA_key').fetch('preview_token')
    @personal_access_token = cf_key_file.fetch('QA_key').fetch('personal_access_token')
  end

  def set_client!
    @client = Contentful::Management::Client.new(@personal_access_token)
  end
end
