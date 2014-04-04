module ApplicationHelper

  def get_option_values(option_type)
    list = Spree::OptionValue.joins(:option_type)
    list = list.where('spree_option_types.name = ?', option_type).map &:presentation
  end

end
