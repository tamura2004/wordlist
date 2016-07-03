class SessionsController < ApplicationController
  def create
    name = cookies.permanent.signed[:name] = params[:name]

    logger.info "cookies.signed[:name] = #{cookies.signed[:name]}"

    @user = {
      name: name
    }
    p @user
    render :show
  end

  def show
    session[:hoge] = "fuga"
    @user = {
      name: cookies.signed[:name]
    }
  end
end
