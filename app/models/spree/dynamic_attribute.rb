module Spree
  module DynamicAttribute

    # NOTE: este metodo genera ruido con la creacion
    # def method_missing(method_name, *args)
    #   super if self.excluded_list.include?(method_name.to_s)
    #   method_name = method_name.to_s
    #   if method_name.ends_with?('=')
    #     method_name = method_name.slice(0, method_name.length-1)
    #     set_option_value(method_name, *args)
    #   else
    #     get_option_value(method_name, *args)
    #   end
    # rescue
    #   super
    # end

    def set_option_values(params, options = {:temporal => false})
      self.save if options[:temporal] == false && self.new_record?
      prefix = params["product_type"]
      product_type = Spree::ProductType.find_by_name(prefix)
      klass = self.class.to_s
      attr_option_types = klass.split('::').last.downcase + "_option_types"
      option_types = product_type.send(attr_option_types)
      params.each do |k, v|
        option_type = option_types.find do |ot|
          if k.index(prefix) == 0
            part = k[prefix.length+1..-1]
            part == ot.name
          else
            ot.name == k
          end
        end
        if option_type
          if options[:temporal]
            set_temporal_option_value(option_type.name, v)
          else
            set_option_value(option_type.name, v)
          end
        end
      end
      if options[:temporal]
        set_temporal_option_value('product_type', params[:product_type])
      end
    end

    def set_temporal_option_values(params)
      set_option_values(params, :temporal => true)
    end

    def set_option_value(option_type, value)
      ot = get_option_type_object(option_type)
      ovr = self.option_values.find {|ov| ov.option_value.option_type_id == ot.id}
      unless ovr
        ovr = "#{self.class.to_s}OptionValue".constantize.new
        self.option_values << ovr
      end
      if ot.attr_type == 'selection'
        ovr.option_value_id = value
      else
        ovr.option_value_id = ot.option_values.first.id
        ovr.value = value
      end
      ovr.save
    end

    def set_temporal_option_value(option_type, value)
      @temporal[option_type.to_s] = value
    end

    def get_mixed_option_value(option_type, options = {:temporal => true})
      if options[:temporal]
        get_temporal_option_value(option_type)
      else
        get_option_value(option_type)
      end
    end

    def get_option_value(option_type, attr='id')
      ot = get_option_type_object(option_type)
      ovr = self.option_values.find {|ov| ov.option_value && ov.option_value.option_type_id == ot.id }
      (ot.attr_type == 'selection' ? ovr.option_value.send(attr) : ovr.value) if ovr
    end

    def get_temporal_option_value(option_type)
      @temporal[option_type.to_s]
    end

    def get_option_type_object(option_type)
      if option_type.is_a?(Symbol)
        option_type = Spree::OptionType.find_by_name(option_type)
      elsif option_type.is_a?(String)
        option_type = Spree::OptionType.find_by_name(option_type)
      elsif option_type.is_a?(Integer)
        option_type = Spree::OptionType.find(option_type)
      end
      option_type
    end

  end
end
