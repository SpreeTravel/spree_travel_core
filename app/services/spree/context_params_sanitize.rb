module Spree
  class ContextParamsSanitize
    def initialize(params:)
      @params = params
    end

    def call
      context_option_types = Spree::ProductType.find_by(name: params['product_type'])
                                               .context_option_types.pluck(:name)
                                               .map {|context| "#{params['product_type']}_#{context}" }

      context_params = params.require(:context).permit(context_option_types)


      context_params.transform_keys{|k,v| k.delete_prefix(params['product_type'] + '_').to_sym}
    end

    private

    attr_reader :params
  end
end


