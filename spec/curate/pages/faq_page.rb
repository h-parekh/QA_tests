module Curate
  module Pages
    # /about
    class FaqPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        # Fill out selectors etc.
        true
      end
    end
  end
end
