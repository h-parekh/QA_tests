# frozen_string_literal: true
module ResponsiveHelpers
  def self.resize_window_to_mobile(mode)
    resize_window_by([640, 480], mode)
  end

  def self.resize_window_to_tablet(mode)
    resize_window_by([1024, 768], mode)
  end

  def self.resize_window_default(mode)
    require 'byebug'; debugger
    resize_window_by([1280, 800], mode)
  end

  private
  def self.resize_window_by(size, mode)
    if mode == 'landscape'
      Capybara.current_window.resize_to(size[0], size[1])
    elsif mode == 'portrait'
      Capybara.current_window.resize_to(size[1], size[0])
    end
  end
end
