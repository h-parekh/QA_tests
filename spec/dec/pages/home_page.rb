# frozen_string_literal: true

module Dec
  module Pages
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host) || current_url == File.join(Capybara.app_host, '/')
      end

      def valid_page_content?
        within('.collectionscover') do
          has_css?('span', text: 'Digital Collections')
        end
        within('.brand-bar') do
          find('a', exact_text: 'UNIVERSITY of NOTRE DAME') &&
            find('a', exact_text: 'HESBURGH LIBRARIES')
        end
        first('div', text: 'Featured Collections')
      end

      def click_collections_page
        first('span', text: 'Explore', visible: false).click
      end
    end
  end
end
