module Curate
  module Pages
    class ImagePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          hasInputFields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/images/new')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Describe Your Image")
      end

      def hasInputFields?
        has_field?("image[title]")
        has_field?("image[rights]")
        has_field?("image[date_created]")
        has_css?("div.control-group.text.optional.image_description")
      end
    end
  end
end
