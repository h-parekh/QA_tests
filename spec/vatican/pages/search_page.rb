module Vatican
  module Pages

    class SearchPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
        status_response_ok? &&
        valid_page_content?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'search?q=')
      end

      def status_response_ok?
        true
        #status_code == 200
      end

      def valid_page_content?
        #true
        sleep(2)
        #has_content?("Loading...")
        has_field?("SEARCH THE DATABASE")
        #within("col-sm-12") do
        #puts(page.all('input').count)

        #page.has_selector?(:xpath, '//*[@id="content"]/div/div/div/div[2]/div/div[2]/div/div[1]/div/div[1]/input')
        #within("col-sm-12") do

        #  page.has_selector?("input[value='Search The Database']")
        #end
      end
    end
  end
end
