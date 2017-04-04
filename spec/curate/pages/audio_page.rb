module Curate
  module Pages
    class AudioPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          hasInputFields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/audios/new')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Describe Your Audio")
      end

      def hasInputFields?
        has_field?("audio[title]")
        has_field?("audio[rights]")
        has_css?("div.control-group.text.optional.audio_description")
      end
    end
  end
end
