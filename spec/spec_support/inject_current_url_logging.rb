module InjectCurrentUrlLogging
  def click(*args, &block)
    super.tap {
      Logging.logger['curate'].info(message_for(event: :click))
    }
  end

  def submit(*args, &block)
    super.tap {
      Logging.logger['curate'].info(message_for(event: :submit))
    }
  end

  def visit(*arg, &block)
    super.tap {
      Logging.logger['curate'].info(message_for(event: :visit))
    }
  end

  private

  def message_for(event:)
     %(context: "#{event}"\tpath: "#{current_path}"\thost: "#{Capybara.app_host}"\t)
  end
end

class Capybara::Poltergeist::Browser
  include InjectCurrentUrlLogging
end
class Capybara::Poltergeist::Node
  include InjectCurrentUrlLogging
end
