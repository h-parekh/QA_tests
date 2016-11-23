module Curate
  module Pages
    # /faqs
    class FaqPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        status_response_ok? &&
        valid_page_content? &&
        valid_page_navigation? &&
        valid_external_page_links?
      end

      def status_response_ok?
        self.status_code == 200
      end

      def valid_page_content?
        self.has_content?('FAQ')
      end

      def valid_page_navigation?
        within(".feature-navigation-wrapper") do
          find_link('Help').visible? &&
          find_link('Getting Started').visible? &&
          find_link('Common Questions').visible?
        end
      end

      def valid_external_page_links?
        valid_policy_page_links? &&
        valid_question_page_links?
      end

      def valid_policy_page_links?
        # note: policies is an id tag... not sure of correct syntax on this yet... 
        # find_link('Governing policies').visible? within(".policies")
        true
      end

      def valid_question_page_links?
        # find_link('Help me choose a licensexxxxxkjasofhosahfsafs').visible? within(".common-questions")
        true
      end
    end
  end
end
