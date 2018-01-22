# frozen_string_literal: true
require 'seaside/seaside_spec_helper'

module Seaside
  module Pages
    class OralHistPage < BasePage
      include Capybara::DSL
      include CapybaraErrorIntel::DSL

      def on_page?
        super &&
          has_videos? &&
          has_video_titles? &&
          on_valid_url?
      end

      def on_valid_url?
        current_url == File.join(Capybara.app_host, 'essays/oral-histories') || File.join(Capybara.app_host, "essays/oral-histories#")
      end

      def has_videos?
        within('.article') do
          all('iframe.player', count: 9).each do |video|
            video.visible?
          end
        end
      end

      def has_video_titles?
        within('.article') do
          all('hgroup.movie-title', count: 9).each do |title|
            title.visible?
          end
        end
      end
    end
  end
end
