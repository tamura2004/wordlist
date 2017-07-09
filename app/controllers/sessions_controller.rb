class SessionsController < ApplicationController

  def new
    if current_user
      redirect_to :root
    else
      @form = LoginForm.new
      render action: "new"
    end
  end

  def create
    @form = LoginForm.new(params[:login_form])

    if @form.number.present?
      user = User.find_by(number: @form.number)
    end

    if user
      session[:user_id] = user.id
      redirect_to :root
    else
      render action: "new"
    end
  end

  def show
    @user = { name: cookies.signed[:name] }
  end

  def destroy
    session.delete(:user_id)
    redirect_to :login
  end

end
