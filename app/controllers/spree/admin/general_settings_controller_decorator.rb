Spree::Admin::GeneralSettingsController.class_eval do

      def edit
        @preferences_cart = [:use_cart]
        @preferences_security = [:check_for_spree_alerts]
      end


end
