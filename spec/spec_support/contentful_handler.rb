# frozen_string_literal: true
require 'forwardable'
# This class provides support to interact with the following contentful APIs:
# * Content Delivery API: https://www.contentful.com/developers/docs/references/content-delivery-api/
# * Content Management API: https://www.contentful.com/developers/docs/references/content-management-api/
# * Content Preview API: https://www.contentful.com/developers/docs/references/content-preview-api/
# * Images API: https://www.contentful.com/developers/docs/references/images-api/

class ContentfulHandler
  # Create a Contentful entry of the given content type. When the block is closed, delete the entry.
  #
  # @param [#info, #debugger] current_logger
  # @param [String] content_type - default to "page"
  # @yieldparam [ContentfulEntryWrapper] entry that is created within the scope of this block
  # @return true - Regardless of the yielded block, we will return true
  def self.create(current_logger:, content_type: 'page')
    handler = new(current_logger: current_logger)
    title = 'Testing_page_' + RunIdentifier.get
    slug = title
    entry = handler.create_entry(title: title, slug: slug, content_type: content_type)
    yield(entry)
    return true
  ensure
    begin
      entry.destroy
    rescue StandardError => e
      current_logger.debug(context: "Failed to clean up entry. This may be okay, as it could have already been cleaned up. Exception: #{e.inspect}", page_title: title)
    end
  end

  # Prefer the .create method instead; It will ensure proper clean-up
  private_class_method :new

  attr_reader :client, :current_logger, :client, :preview_client, :space_id
  def initialize(current_logger:)
    @current_logger = current_logger
    read_contentful_tokens
    set_clients!
  end

  def create_entry(title:, slug:, content_type:)
    current_logger.info(context: "Finding content type '#{content_type}' in contentful", content_type: content_type)
    contentful_content_type = client.content_types.find(@space_id, content_type)
    current_logger.info(context: "Creating page in contentful", page_title: title)
    entry = client.entries.create(contentful_content_type, title: title, slug: slug)
    current_logger.info(context: "Created page in contentful", page_title: title, contentful_entry_id: entry.id)
    ContentfulEntryWrapper.new(entry: entry, handler: self)
  end

  private

  def read_contentful_tokens
    cf_key_file = YAML.load_file(File.join(ENV.fetch('HOME'), 'test_data/QA/cf_api_key.yml'))
    qa_key = cf_key_file.fetch('QA_key')
    @space_id = qa_key.fetch('space_id')
    @cdn_token = qa_key.fetch('cdn_token')
    @preview_token = qa_key.fetch('preview_token')
    @personal_access_token = qa_key.fetch('personal_access_token')
  end

  def set_clients!
    @client = Contentful::Management::Client.new(@personal_access_token)
    @preview_client = Contentful::Client.new(space: "#{@space_id}", access_token: "#{@preview_token}", api_url: 'preview.contentful.com')
  end

  class ContentfulEntryWrapper
    extend Forwardable
    attr_reader :entry, :handler
    def initialize(entry:, handler:)
      @entry = entry
      @handler = handler
    end
    def_delegators :@handler, :current_logger, :client, :preview_client, :space_id
    def_delegators :@entry, :published?, :title, :slug, :id

    def make_previewable!
      current_logger.info(context: "Making page previewable", page_title: entry.title, contentful_entry_id: entry.id)
      preview_client.entry(entry.id)
    end

    def delete
      title = entry.title
      contentful_entry_id = entry.id
      current_logger.info(context: "Deleting page", page_title: title, contentful_entry_id: contentful_entry_id)
      entry.destroy
      current_logger.info(context: "Page has been deleted", page_title: title, contentful_entry_id: contentful_entry_id)
    end

    # If the found response is of a different type that the entry we know it is gone.
    # A successful find will return a Contentful::Management::DynamicEntry[content_type] object
    # An unsuccessful find will return a Contentful::Management::NotFound object
    def deleted?
      response = client.entries.find(space_id, entry.id)
      return !response.is_a?(entry.class)
    end
  end
end
