Spree::UserSessionsController.class_eval do

  def create
    authenticate_user!

    go_path = params[:current] || root_path

    if user_signed_in?
      respond_to do |format|
        format.html {
          flash.notice = t('logged_in_succesfully')
          redirect_back_or_default(go_path)
        }
        format.js {
          user = resource.record
          render :json => {:ship_address => user.ship_address, :bill_address => user.bill_address}.to_json
        }
      end
    else
      flash.now[:error] = t('devise.failure.invalid')
      go_path += '?login_error=true'
      redirect_back_or_default(go_path)
    end
  end

end