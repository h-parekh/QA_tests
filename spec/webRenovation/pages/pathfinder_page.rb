module WebRenovation
  module Pages
    class PathfinderPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          has_services? &&
          has_guides? &&
          has_resources? &&
          has_location_hours? &&
          has_location? &&
          has_librarians?
      end

      def has_services?
        within('.p-services') do
          all('li', minimum: 1)
        end
      end

      def has_guides?
        within('.p-guides') do
          all('li', minimum: 1)
        end
      end

      def has_resources?
        first('.p-resources').has_selector?('li', minimum: 1)
      end

      def has_location_hours?
        find('.service-point').visible?
      end

      def has_librarians?
        all('.librarian', minimum: 1)
      end

      def has_location?
        find('.point').visible?
      end
    end
  end
end
