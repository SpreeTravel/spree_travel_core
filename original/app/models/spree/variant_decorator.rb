Spree::Variant.class_eval do
  attr_accessible :product_id, :sku, :price, :option_types, :option_values , :position
  has_many :relations, :as => :relatable

  #acts_as_solr :fields => [:adults, :children, :infants, :init_date, :end_date, :meal_plan, :transmission, :confort, :duration, :trip_type, :packs]

  def adults
    value = find_value_for_option('adult')
    value.split('-')[1].to_i rescue 0
  end

  def children
    value = find_value_for_option('child')
    value.split('-')[1].to_i rescue 0
  end

  def infants
    value = find_value_for_option('infant')
    value.split('-')[1].to_i rescue 0
  end

  def init_date
    value = find_value_for_option('from')
    return nil if value.nil?
    date = value.split('-')[1]
    date.to_date
  end

  def end_date
    value = find_value_for_option('from')
    return nil if value.nil?
    date = value.split('-')[3]
    #day, month, year = date.split('/')
    #"#{year}/#{month}/#{day}".to_date
    date.to_date
  end

  def meal_plan
    value = find_value_for_option('meal-plan')
    return nil if value.nil?
    #parts = value.split('-')
    #parts[2..-1].join('-')
    value
  end

  def transmission
    value = find_value_for_option('transmission')
    return nil if value.nil?
    #parts = value.split('-')
    #parts[2..-1].join('-')
    value
  end

  def confort
    value = find_value_for_option('taxi-confort')
    return nil if value.nil?
    value
  end

  def duration
    value = find_value_for_option('duration')
    return nil if value.nil?
    p = value.split('-')[1]
    init_range, end_range = p.split('..')
    Range.new(init_range.to_i, end_range.to_i)
  end

  def trip_type
    value = find_value_for_option('trip')
    return nil if value.nil?
    value
  end

  def packs
    value = find_value_for_option('pax')
    return nil if value.nil?
    p = value.split('-')[1]
    init_range, end_range = p.split('..')
    Range.new(init_range.to_i, end_range.to_i)
  end

  def find_value_for_option(option_type_name)
    self.option_values.map(&:name).each do |ovn|
      return ovn if ovn.start_with?(option_type_name)
    end
    nil
  end

  def order_values
    values = self.option_values.order(:position).map(&:name).join('|')
    values
  end

end
