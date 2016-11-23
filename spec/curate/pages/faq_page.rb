module Curate
  module Pages
    # /about
    class FaqPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        self.status_code == 200 &&
        self.has_content?('FAQ') &&
        find_link('Getting Started').visible? &&
        find_link('Common Questions').visible? &&
        find_link('Governing policies').visible? &&
        find_link('Help me choose a license').visible?
      end
    end
  end
end
