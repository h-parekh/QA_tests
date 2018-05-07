# frozen_string_literal: true

module Curate
  module Pages
    # /departments
    class DepartmentsPage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        on_valid_url? &&
          status_response_ok? &&
          valid_header_links? &&
          valid_page_content? &&
          valid_external_page_links?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'departments')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        within('.main-header') do
          return false unless has_content?('Browse Items by Department or Unit')
        end
        within(".page-footer-wrapper") do
          return false unless has_link?('Help')
        end
        true
      end

      def valid_header_links?
        within(".title-bar-wrapper") do
          has_link?('About') &&
            has_link?('FAQ')
        end
      end

      def has_link?(text)
        has_selector?(:link, text)
      end

      def valid_external_page_links?
        within('.department-listing') do
          all('ul li').count > 0
        end
      end

      def select_random_departmental_link
        within('.department-listing') do
          node = find('.facet-hierarchy')
          node_list = node.all('li')
          count_links = node_list.count
          random = rand(count_links)
          link = node_list[random]
          # count of items in random link
          link_count = link.all('.count').first.text
          # link name
          link_text = link.all('a').first.text
          # link to next page
          link_url = link.all('a').first['href']
          return DepartmentalLink.new(count: link_count, caption: link_text, link: link_url)
        end
      end
    end

    class DepartmentalLink
      attr_reader :count, :caption, :link

      def initialize(count:, caption:, link:)
        @count = count
        @caption = caption
        @link = link
      end
    end
  end
end
