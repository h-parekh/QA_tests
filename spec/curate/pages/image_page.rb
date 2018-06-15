# frozen_string_literal: true

require 'date'

module Curate
  module Pages
    class ImagePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def initialize
        VerifyNetworkTraffic.exclude_uri_from_network_traffic_validation.push('/assets/ui-bg_highlight-soft_100_eeeeee_1x100.png')
      end

      def on_page?
        on_valid_url? &&
          valid_page_content? &&
          has_input_fields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/images/new')
      end

      def valid_page_content?
        has_content?("Describe Your Image")
      end

      def has_input_fields?
        has_field?("image[title]")
        has_field?("image[rights]")
        has_field?("image[date_created]")
        has_css?("div.control-group.text.optional.image_description")
      end

      def create_temp_image(access_rights: nil, embargo_date: true)
        fill_in(id: "image_title", with: "foo")
        fill_in(id: "image_creator", with: "foo")
        within('#set-access-controls') do
          if ['ndu', 'open', 'restricted'].include?(access_rights)
            choose(id: 'visibility_' + access_rights)
          elsif access_rights == 'embargo'
            choose(id: 'visibility_' + access_rights)
            if embargo_date
              fill_in(id: 'image_embargo_release_date', with: Date.today + 1)
            end
          else
            choose(id: 'visbility_open')
          end
        end
        find('#accept_contributor_agreement').click
        find('.btn.btn-primary.require-contributor-agreement').click
      end
    end
  end
end
