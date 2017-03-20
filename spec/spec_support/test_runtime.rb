# frozen_string_literal: true
require 'fileutils'

module RunIdentifier

  def self.set
    @run_identifier = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%L-05:00")
  end

  def self.get
    @run_identifier
  end

  def self.remove_oldest_directory(dir: 'tmp/screenshots')
    oldest_directory = Dir.glob('*').select {|f| File.directory? f}.sort_by{|f| File.ctime(f)}.first
    FileUtils.rm_rf(oldest_directory)
  end

<<<<<<< HEAD
  def self.setup(runs: 5)
=======
  def self.get_screenshots_save_path(runs: 5)
    n_runs = runs
>>>>>>> Improved readability of test_runtime.rb
    screenshots_root = 'tmp/screenshots/'
    current_working_directory = Dir.pwd
    Dir.chdir(screenshots_root)
    screenshots_directories = Dir.glob('*').select {|f| File.directory? f} # Returns a list of all screenshots directories in screenshots_root
    num_directories = screenshots_directories.length
    while num_directories >= runs do # Removes all but the newest runs screenshot directories
      self.remove_oldest_directory()
      num_directories=num_directories-1
    end

    FileUtils.mkdir self.get
    Dir.chdir(current_working_directory) # Return to current directory so screenshots are in the right place
    File.join(screenshots_root,self.get)
  end
end
