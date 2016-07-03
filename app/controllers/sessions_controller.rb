class SessionsController < ApplicationController
  def create
    name = cookies.permanent.signed[:name] = params[:name]
    @user = {name: name}
    render :show
  end

  def show
    @user = {name: cookies.signed[:name]}
  end
end
