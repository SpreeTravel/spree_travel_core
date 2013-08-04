Spree::OrderMailer.class_eval do

    def user_confirmation_email(order, resend=false)
      @order = order
      subject = (resend ? "[#{t('resend').upcase}] " : "")
      subject += "#{Spree::Config[:site_name]} #{t('order_mailer.user_confirmation_email.subject')} #{order.number}"
      mail(:to => order.email,
           :subject => subject)
    end

end
