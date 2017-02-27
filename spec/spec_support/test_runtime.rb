# frozen_string_literal: true
require 'fileutils'
module RunIdentifier
  attr_accessor :n_runs
  def self.set
    @run_identifier = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%L-05:00")
  end

  def self.get
    @run_identifier
  end

  def self.remove_oldest(dir: 'tmp/screenshots')
    oldest = Dir.glob('*').select {|f| File.directory? f}.sort_by{|f| File.ctime(f)}.first
    FileUtils.rm_rf(oldest)
  end

  def self.setup(runs: 5)
    screenshots_root = 'tmp/screenshots/'
    cwd = Dir.pwd
    Dir.chdir(screenshots_root)
    directories = Dir.glob('*').select {|f| File.directory? f}
    if directories.length == n_runs
      self.remove_oldest()
    end

    FileUtils.mkdir self.get
    Dir.chdir(cwd) # Return to current directory so screenshots are in the right place
    File.join(screenshots_root,self.get)
  end
end
