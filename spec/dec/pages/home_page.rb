# frozen_string_literal: true
module Dec
  module Pages
    # /
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host)
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('.collectionscover') do
          has_css?('span', :text => 'Digital Collections') 
        end
        within('.brand-bar') do 
          find_link('University of Notre Dame', :href => 'http://www.nd.edu') &&
          find_link('Hesburgh Libraries', :href => 'http://library.nd.edu')
        end
        first('div', :text => 'Featured Collections')
      end
      def on_collections_page?
        str = Capybara.app_host.gsub("\.", "\\.") + '[A-z0-9]{10}/[A-Za-z0-9]+(?:-[A-Za-z0-9]+)*$'
        require 'byebug' ; debugger
        %r[#{str}].match(current_url)
      end
    end
  end
end
