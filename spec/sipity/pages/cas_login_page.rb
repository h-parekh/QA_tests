# frozen_string_literal: true
require 'csv'
require 'sipity/sipity_spec_helper'

class LoginPage
  def on_page?
    on_valid_url? &&
      status_response_ok? &&
      valid_page_content?
  end

  def on_valid_url?
    current_url.start_with?('https://login.nd.edu/cas/login')
  end

  def status_response_ok?
    status_code.to_s.match(/^20[0,1,6]$/)
  end

  def valid_page_content?
    page.has_content?("Login to Curate")
    find('#password')
    find('#username')
    find('button[name="submit"]', :text => 'LOGIN')
  end
end
