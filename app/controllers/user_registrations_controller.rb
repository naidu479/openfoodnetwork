class UserRegistrationsController < Spree::UserRegistrationsController
  before_filter :set_checkout_redirect, only: :create

  # POST /resource/sign_up
  def create
   p "*"*100
    @user = build_resource(params[:spree_user])
   if resource.save
     set_flash_message(:success, :signed_up)
      begin 
      p "sent email"
      Spree::UserMailer.signup_confirmation(@user).deliver_now
      rescue
         p "not sending email"
      end 
      sign_in(:spree_user, @user)
       p @user
      if Spree::Order.where(email: @user.email).exists?
        @u_orders = Spree::Order.where(email: @user.email)
        @u_orders.update_all(user_id: @user.id) if @u_orders.count > 0
      end
      session[:spree_user_signup] = true
      associate_user

      respond_to do |format|
        format.html do
          sign_in_and_redirect(:spree_user, @user)
        end
        format.js do
          render json: { email: @user.email }
        end
      end
    else
      clean_up_passwords(resource)
      respond_to do |format|
        format.html do
          render :new
        end
        format.js do
          render json: @user.errors, status: :unauthorized
        end
      end
    end
  end
end
