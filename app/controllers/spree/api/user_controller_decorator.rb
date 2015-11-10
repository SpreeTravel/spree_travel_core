Spree::Api::UsersController.class_eval do

  # Action to authenticate and return a new token for api key.
  def token
    if @user = Spree.user_class.find_for_database_authentication(login: user_params[:email])
      if @user.valid_password? user_params[:password]
        @user.generate_spree_api_key! unless @user.spree_api_key
        render json: {id: @user.id, email: @user.email, token: @user.spree_api_key}
      else # Wrong Password
        render json: {errors: {password: "incorrect"}}, status: 422
      end
    else # User Not Found
      render json: {errors: {email: "not found"}}, status: 422
    end
  end

end
