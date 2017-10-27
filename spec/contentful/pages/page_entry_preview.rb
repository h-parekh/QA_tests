# frozen_string_literal: true
module ContentfulTests
  module Pages
    class PageEntryPreview
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize(contentful_entry)
        @contentful_entry = contentful_entry.fetch(:contentful_entry)
      end

      def on_page?
        correct_url? &&
          correct_content?
      end

      def correct_content?
        require 'byebug'; debugger
        find('.page-title', text: "#{@contentful_entry.title}")
      end

      def correct_url?
        current_url == File.join(Capybara.app_host, "#{@contentful_entry.slug}?preview=true")
      end
    end
  end
end
