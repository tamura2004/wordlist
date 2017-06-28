class SessionsController < ApplicationController

  def new
    if current_user
      redirect_to :root
    else
      render action: "new"
    end
  end

  def create
    @user = User.find_by(number: params[:number])

    if @user && @user.password?(params[:password])
      session[:user_id] = @user.id
    end

    # name = cookies.permanent.signed[:name] = params[:name]
    # @user = { name: name }
    # render :show
  end

  def show
    @user = { name: cookies.signed[:name] }
  end
end
