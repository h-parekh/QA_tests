module Curate
  module Pages
    class ShowArticlePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      attr_reader :article_title

      def initialize(title: '')
        @article_title = title
      end

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content?
      end

      def on_valid_url?
        current_url.include? 'show'
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?(@article_title)
        within("div.actions") do #find the View details and downloads button
          find("a.action.btn", :text => "Download")
          find("a.btn", :text => "View Details")
        end
        #Make sure that the Abstract and Attributes sections have text
        within("article.abstract.descriptive-text") do
          find('p')
        end
        within("div.work-attributes.span9") do
	         has_css?('p', minimum: 2)
        end
      end
    end
  end
end
