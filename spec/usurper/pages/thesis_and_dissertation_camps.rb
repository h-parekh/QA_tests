# frozen_string_literal: true
module Usurper
  module Pages
    # /personal
    class ThesisCampsCheck < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
        on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host,  'thesis-dissertation-camps') || current_url == File.join(Capybara.app_host,  'thesis-dissertation-camps#')
      end
    end
  end
end
