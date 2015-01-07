def params_for_dynamic_attribute(product)
  context_params = {}
  context_params['product_type'] = product.product_type.name
  prefix = context_params['product_type']

  product.context_option_types.each do |ot|
    context_params[prefix+'_'+ot.name] = ot.option_values.first.name
  end

  context_params
end