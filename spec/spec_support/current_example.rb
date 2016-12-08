class CurrentExample
  DEFAULT_ENVIRONMENT = 'prod'

  attr_reader :application_name_under_test, :spec_sub_directory, :spec_helper_path, :config, :environment_under_test, :example

  def initialize(example:, config: ENV)
    @example = example
    @config = config
    @environment_under_test = config.fetch('ENVIRONMENT', DEFAULT_ENVIRONMENT)
    @spec_helper_path = File.expand_path('../../', __FILE__)
    @current_logger = CurrentLogger.new(example: self)
    initialize_example_variables!
    initialize_app_host!
  end

  def run(&block)
    @current_logger.info(context: "example", example: example.full_description, &block)
  end

  private

  def initialize_example_variables!
    spec_path = @example.metadata.fetch(:absolute_file_path)
    @spec_sub_directory = spec_path.sub("#{spec_helper_path}/", '').split('/')
    @application_name_under_test = spec_sub_directory.first
  end

  def initialize_app_host!
    servers_by_environment = YAML.load_file(
      File.expand_path("./#{application_name_under_test}/#{application_name_under_test}_config.yml", spec_helper_path)
    )
    Capybara.app_host = servers_by_environment.fetch(environment_under_test)
  end
end

class CurrentLogger
  def initialize(example:)
    @example = example
    initialize_logger!
  end

  def info(context:, **kwargs, &block)
    log(severity: __method__, context: context, **kwargs, &block)
  end
  def debug(context:, **kwargs, &block)
    log(severity: __method__, context: context, **kwargs, &block)
  end
  def fatal(context:, **kwargs, &block)
    log(severity: __method__, context: context, **kwargs, &block)
  end
  def warn(context:, **kwargs, &block)
    log(severity: __method__, context: context, **kwargs, &block)
  end
  def error(context:, **kwargs, &block)
    log(severity: __method__, context: context, **kwargs, &block)
  end

  private

  def initialize_logger!
    @logger = Logging.logger[application_name_under_test]
    Logging.appenders.stdout(layout: Logging.layouts.pattern(format_as: :json))

    @logger.add_appenders('stdout')
    @logger.level = :info
  end

  def application_name_under_test
    @example.application_name_under_test
  end

  def log(severity:, context:, **kwargs, &block)
    message = ""
    kwargs.each_with_object(message) { |(key, value), obj| obj += %(#{key}: "#{value.inspect}") }

    if block_given?
      @logger.public_send(severity, %(context: "STARTING #{context}\t#{message}))
      yield
      @logger.public_send(severity, %(context: "STOPPING #{context}\t#{message}))
    else
      @logger.public_send(severity, %(context: #{context}\t#{message}))
    end
  end
end
