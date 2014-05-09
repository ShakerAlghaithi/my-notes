class UsersController < ApplicationController
   def index
        @user = User.all
   end
   
   def show
        @user = User.find(params[:id])
   end

   def new
        @user = User.new
   end

   def create
        @user = User.new(user_params)
        if @user.save
              flash[:success] = "Welcome to MY_NoTE app!"
              sign_in @user
              redirect_to notes_path
         else
              flash[:error] = "Failed to create account.  Try again."
              redirect_to new_user_path
          end
    end

    def update
          @user = User.find(params[:id])
          @user.update_attributes(user_params)
          redirect_to @user
    end
    
    def google_oauth2
          @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

         if @user.persisted?
             flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
             sign_in_and_redirect @user, :event => :authentication
         else
              session["devise.google_data"] = request.env["omniauth.auth"]
              redirect_to new_user_registration_url
         end
     end

   private
     def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
     end
end
   

