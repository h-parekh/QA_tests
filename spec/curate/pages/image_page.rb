require 'date'

module Curate
  module Pages
    class ImagePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
          on_valid_url? &&
          status_response_ok? &&
          valid_page_content? &&
          hasInputFields?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'concern/images/new')
      end

      def status_response_ok?
        status_code == 200
      end

      def valid_page_content?
        has_content?("Describe Your Image")
      end

      def hasInputFields?
        has_field?("image[title]")
        has_field?("image[rights]")
        has_field?("image[date_created]")
        has_css?("div.control-group.text.optional.image_description")
      end

      def createTempImage(access_rights: nil, embargo_date: true)
        fill_in(id: "image_title", with: "foo")
        fill_in(id: "image_creator", with: "foo")
        within('#set-access-controls') do
          if access_rights == 'ndu' || access_rights == 'open' || access_rights == 'restricted'
            choose(id: 'visibility_' + access_rights)
          elsif access_rights == 'embargo'
            choose(id: 'visibility_' + access_rights)
            if embargo_date
              fill_in(id: 'image_embargo_release_date', with: Date.today+1)
            end
          else
            choose(id: 'visbility_open')
          end
        end
        find('#accept_contributor_agreement').trigger('click')
        find('.btn.btn-primary.require-contributor-agreement').trigger('click')
      end
    end
  end
end
