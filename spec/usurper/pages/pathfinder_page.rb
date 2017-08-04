module Usurper
  module Pages
    class PathfinderPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize(general_pathfinder_format: true)
        @general_pathfinder_format = general_pathfinder_format
      end


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
        if @general_pathfinder_format
          first('.p-services').has_selector?('li', minimum: 1)
        else
          true
        end
      end

      def has_guides?
        if @general_pathfinder_format
          within('.p-guides') do
            all('li', minimum: 1)
          end
        else
          true
        end
      end

      def has_resources?
        if @general_pathfinder_format
          first('.p-resources').has_selector?('li', minimum: 1)
        else
          true
        end
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
