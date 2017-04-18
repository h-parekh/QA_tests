# frozen_string_literal: true
require 'fileutils'

module RunIdentifier
  def self.set
    @run_identifier = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%L-05:00")
  end

  def self.get
    @run_identifier
  end

  # * Create tmp/screenshots dir if not present
  # * Remove directories older than value specified in argument
  # * returns a relative path of the directory to which current test should save screenshots
  # @example 'tmp/screenshots/2017-04-17T12:03:57.859-05:00'
  # @return [String]
  def self.get_screenshots_save_path(runs: 5)
    screenshots_root = 'tmp/screenshots/'
    current_working_directory = Dir.pwd
    FileUtils.mkdir_p(screenshots_root)
    Dir.chdir(screenshots_root)
    screenshots_directories = Dir.glob('*').select { |f| File.directory? f } # Returns a list of all screenshots directories in screenshots_root
    screenshots_directories.reverse.each_with_index { |dir, index|
      if index>=runs
        FileUtils.rm_rf(dir)
      end
    }

    # Using value of @run_identifier as directory name
    FileUtils.mkdir self.get
    Dir.chdir(current_working_directory) # Return to current directory so screenshots are in the right place
    File.join(screenshots_root, self.get)
  end
end
