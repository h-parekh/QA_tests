# frozen_string_literal: true
class LoginPage
  def checkLoginPage
    page.has_content?("Login to Curate")
    find('#password')
    find('button[name="submit"]', :text => 'LOGIN')
  end
end
