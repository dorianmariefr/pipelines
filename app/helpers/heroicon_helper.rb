# frozen_string_literal: true

module HeroiconHelper
  include Heroicon::Engine.helpers

  ICON_LINK_CLASSES = "w-5 h-5 opacity-75 hover:opacity-100"

  def icon_link(sr_only, icon, path, **options)
    options[:class] ||= ""
    options[:class] = "#{options[:class]} #{ICON_LINK_CLASSES}".strip

    link_to path, **options do
      safe_join([content_tag(:div, sr_only, class: "sr-only"), heroicon(icon)])
    end
  end
end
