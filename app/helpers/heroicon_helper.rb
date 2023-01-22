# frozen_string_literal: true

module HeroiconHelper
  include Heroicon::Engine.helpers

  def heroicon(*args, **kargs, &block)
    kargs[:options] ||= {}
    kargs[:options][:width] ||= 20
    kargs[:options][:height] ||= 20
    super(*args, **kargs, &block)
  end
end
