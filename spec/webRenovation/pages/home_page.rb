# frozen_string_literal: true
module WebRenovation
  module Pages
    # /
    class HomePage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          has_nd_branding? &&
          has_valid_searchbox? &&
          has_service_boxes? &&
          has_news? &&
          has_events? &&
          has_hours?
      end

      def on_valid_url?
        current_url == Capybara.app_host || current_url == (Capybara.app_host + "/")
      end

      def has_nd_branding?
        within('#wrapper') do
          find_link('University of Notre Dame').visible?
        end
      end

      def has_valid_searchbox?
        find_by_id('searchAppliance') &&
          find_button('Search')
      end

      def has_service_boxes?

        within('.row.services') do
          # Reserves
          find_link(:href => 'https://reserves.library.nd.edu', :title => 'Course Reserves')
          # ILL
          find_link(:href => 'https://nd.illiad.oclc.org/illiad/IND/illiad.dll', :title => 'Interlibrary Loan and Document Delivery')
          # Reserve Room
          find_link(:href => 'http://nd.libcal.com/#s-lc-box-2749-container-tab1', :title => 'Reserve a Room')
        end
      end

      def has_news?
        within('.row.news') do
          find('h3', text: 'News') &&
            all('.news-card', between: 1..3)
        end
      end

      def has_events?
        within('.row.news') do
          find('h3', text: 'Events') &&
            all('.event-card', between: 1..3)
        end
      end

      def has_hours?
        # Hours display mid page
        within('.hours-display') do
          find_link(:href => "/page/hours/").text != ''
          find_link(:href => "/page/hours/").text != nil
        end
      end
    end
  end
end
