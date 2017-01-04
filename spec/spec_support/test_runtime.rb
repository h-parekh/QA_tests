# frozen_string_literal: true

module RunIdentifier
  def self.set
    @run_identifier = DateTime.now.strftime("%m%d%Y_%H%M%S.%L")
  end

  def self.get
    @run_identifier
  end
end
