require 'capybara/dsl'
require 'capybara_error_intel/dsl'

module Curate
  module Pages
    # /about
    class AboutPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        # Fill out selectors etc.
        true
      end
    end
  end
end
