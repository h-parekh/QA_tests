# frozen_string_literal: true

module RunIdentifier
  def self.set
    @run_identifier = DateTime.now.strftime("%Y-%m-%dT%H:%M:%S.%L-05:00")
  end

  def self.get
    @run_identifier
  end
end
