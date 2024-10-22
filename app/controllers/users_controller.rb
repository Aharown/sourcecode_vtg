class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])  
    @garments = @user.garments
  end
end
