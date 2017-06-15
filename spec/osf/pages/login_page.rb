# frozen_string_literal: true
require 'csv'
require 'osf/osf_spec_helper'

class LoginPage
  def checkLoginPage
    page.has_content?("Login to Open Science Foundation")
    find('#password')
    find('button[name="submit"]', :text => 'LOGIN')
  end
end
