# frozen_string_literal: true

require 'inquisition/inquisition_spec_helper'

module Inquisition
  module Pages
    class HomePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        require 'byebug'; debugger
        status_response_ok? &&
          on_valid_url? &&
          valid_top_banner? &&
          valid_bottom_banner? &&
          has_facets? &&
          has_title?
      end

      def status_response_ok?
        status_code == 200 || status_code == 304
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'collections/RBSC-INQ:COLLECTION') || current_url == File.join(Capybara.app_host, 'collections/RBSC-INQ:COLLECTION#')
      end

      def valid_top_banner?
        within('.row.header') do
          find_link('Hesburgh Libraries', href: 'http://library.nd.edu/').visible? &&
            find('form.simple.EXLForm').visible?
          within('.row.navigation') do
            find_link('Home', href: 'https://rarebooks.library.nd.edu/') &&
              find_link('Formats', href: 'https://rarebooks.library.nd.edu/finding').visible? &&
              find_link('Digital Projects', href: 'https://rarebooks.library.nd.edu/digital').visible? &&
              find_link('Exhibits', href: 'https://rarebooks.library.nd.edu/exhibits').visible? &&
              find_link('About Us', href: 'https://rarebooks.library.nd.edu/using').visible?
          end
        end
      end

      def valid_bottom_banner?
        within('.row.footer') do
          find("img[src*='http://rarebooks.library.nd.edu/images/hesburgh_mark.png']").visible? &&
            find_link('University of Notre Dame', href: 'http://nd.edu/').visible? &&
            find_link('Rare Books & Special Collections', href: 'https://rarebooks.library.nd.edu/').visible? &&
            find("img[src*='https://rarebooks.library.nd.edu/images/rare.logo.sml.gif']").visible?
        end
      end

      def has_facets?
        within('#facets') do
          find_link('Inquisitorial manuals', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Inquisitorial_manuals').visible? &&
            find_link('Trials and sentencing', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Trials_and_sentencing').visible? &&
            find_link('Autos de fe', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Autos_de_fe').visible? &&
            find_link('Censorship', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Censorship').visible? &&
            find_link('Familiars and officials', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Familiars_and_officials') &&
            find_link('Policies and proceedings', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Policies_and_proceedings') &&
            find_link('Polemics and histories', href: '/collections/RBSC-INQ:COLLECTION/genre/RBSC-INQ:Polemics_and_histories')
        end
      end

      def has_title?
        within('#main-content') do
          find('#collection-title').visible?
        end
      end
    end
  end
end
