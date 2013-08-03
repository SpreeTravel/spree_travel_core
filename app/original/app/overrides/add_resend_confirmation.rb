=begin
Deface::Override.new(:virtual_path => "spree/user_sessions/new",
		     :name => "add_resend_confirmation",
		     :replace => "[data-hook='login']",
		     :text =>  "<%= render :partial => 'spree/shared/login' %>
    <%= t('or') %> <%= link_to t('create_a_new_account'), spree.signup_path %> | <%= link_to t('forgot_password'), spree.new_user_password_path  %> | <%= link_to t('resend_confirmation'), spree.new_user_confirmation_path %>",
         :disable => true)
=end
