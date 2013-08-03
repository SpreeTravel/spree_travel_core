module Spree
  module BannersHelper

    def insert_banner(params={})

      max = params[:max] || 1
      category = params[:category] || ""
      cl = params[:class] || "banner"
      style = params[:style] || "list"
      banner = Banner.enable(category).limit(max)

      if !banner.blank?
        banner = banner.sort_by { |ban| ban.position }
        if (style == "list")
          content_tag(:ul, raw(banner.map do |ban| content_tag(:li, link_to(image_tag(ban.attachment.url(:custom)), '#'), :class => cl) end.join) )
        else
          raw(banner.map do |ban| content_tag(style.to_sym, link_to(image_tag(ban.attachment.url(:custom)), '#'), :class => cl) end.join)
        end

      end
    end
  end
end