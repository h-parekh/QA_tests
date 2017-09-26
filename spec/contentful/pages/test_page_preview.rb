# frozen_string_literal: true
module ContentfulTests
  module Pages
    class TestPagePreview
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
        find('.page-title', text: "#{@contentful_entry.slug}")
      end

      def correct_url?
        current_url == File.join(Capybara.app_host, "#{@contentful_entry.slug}?preview=true")
      end
    end
  end
end
