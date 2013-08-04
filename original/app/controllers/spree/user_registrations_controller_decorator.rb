Spree::UserRegistrationsController.class_eval do

  # POST /resource/sign_up
  def create

    go_path = params[:current] || root_path

    @user = build_resource(params[:user])
    if resource.save
      set_flash_message(:notice, :signed_up)
      sign_in(:user, @user)
      fire_event('spree.user.signup', :user => @user)
      sign_in_and_redirect(:user, @user)
    else
      clean_up_passwords(resource)
      go_path += '?registration_error=true'
      redirect_back_or_default(go_path)
    end
  end

end
