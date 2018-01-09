# frozen_string_literal: true
require 'csv'
require 'curate/curate_spec_helper'

class LoginPage
  def checkLoginPage
    page.has_content?("Central Authentication Service")
    find('#password')
    find('#username')
  end
end
