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
          has_valid_searchbox? &&
          has_service_boxes? &&
          has_news_and_events? &&
          has_hours? &&
          valid_nd_header?
      end

      def on_valid_url?
        current_url == Capybara.app_host || current_url == (Capybara.app_host + "/")
      end

      def valid_nd_header?
        within('#header') do
          find_link('University of Notre Dame', href: 'http://nd.edu').visible? &&
            find_link('Office of the Provost', href: 'http://provost.nd.edu').visible?
        end
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
        within('.services.hservices') do
          # Course Reserves
          find_link(href: '/courses')
          # ILL
          find_link(href: '/items-requests')
          # Subjects A-Z
          find_link(href: '/subjects')
          # Reserve Room
          find_link(href: 'http://nd.libcal.com/#s-lc-box-2749-container-tab1')
          # Tech Lending
          find_link(href: '/technology-lending')
        end
      end

      def has_news_and_events?
        within('.row.news') do
          find('h3', text: 'News') &&
            all('.news-card', between: 1..3)
          find('h3', text: 'Events') &&
            all('.event-card', between: 1..3)
        end
      end

      def has_hours?
        # Hours display mid page
        within('.hours-display') do
          !find_link(href: "/hours").text.nil?
        end
      end
    end
  end
end
