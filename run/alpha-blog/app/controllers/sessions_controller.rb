class SessionsController < ApplicationController

  def new
  end

  def create

      user = User.find_by(email: params[:session][:email].downcase)
      
      if user && user.authenticate(params[:session][:password])
        session[:user_id] = user.id
        flash[:notice] = "Logged in successfully...."
        redirect_to user
      else
        puts "ERROR"
        flash.now[:alert] = "There was something wrong with your login details..." 
        render :new, status: :unprocessable_entity
      end

  end

  def destroy

    puts "DESTROY"

    session[:user_id] = nil

    flash[:notice] = "Logged out"

    redirect_to root_path, status: 303      # must return 303 to indicate success

  end

end