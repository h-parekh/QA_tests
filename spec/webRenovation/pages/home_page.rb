# frozen_string_literal: true
module WebRenovation
  module Pages
    # /
    class HomePage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          on_valid_url? &&
          has_nd_branding? &&
          searchbox_valid? &&
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

      def searchbox_valid?
        find_by_id('searchAppliance') &&
          find_button('Search')
      end

      def has_service_boxes?
        # Reserves
        find_link(:href => 'https://reserves.library.nd.edu', :title => 'Course Reserves')
        # ILL
        find_link(:href => 'https://nd.illiad.oclc.org/illiad/IND/illiad.dll', :title => 'Interlibrary Loan and Document Delivery')
        # Reserve Room
        find_link(:href => 'http://nd.libcal.com/#s-lc-box-2749-container-tab1', :title => 'Reserve a Room')
      end

      def has_news?
        find('h3', text: 'News') &&
          all('.news-card', between: 1..3)
      end

      def has_events?
        find('h3', text: 'Events') &&
          all('.event-card', between: 1..3)
      end

      def has_hours?
        # Hours display mid page
        all(:css, 'a[href="/page/hours/"]')[0].text != ''
        all(:css, 'a[href="/page/hours/"]')[0].text != nil

        # Hours button in footer
        find_link(:href => '/page/hours/', :class =>'hours')
      end
    end
  end
end
