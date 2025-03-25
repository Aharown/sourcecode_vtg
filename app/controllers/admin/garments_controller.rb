class Admin::GarmentsController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @garments = Garment.all
  end

  def new
    @garment = Garment.new
  end

  def create
    @garment = Garment.new(garment_params)
    if @garment.save
      redirect_to admin_garments_path, notice: 'Garment created successfully.'
    else
      render :new
    end
  end

  def edit
    @garment = Garment.find(params[:id])
  end

  def update
    @garment = Garment.find(params[:id])
    if @garment.update(garment_params)
      redirect_to admin_garments_path, notice: 'Garment updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @garment = Garment.find(params[:id])
    @garment.destroy
    redirect_to admin_garments_path, notice: 'Garment deleted successfully.'
  end

  private

  def garment_params
    params.require(:garment).permit(:name, :description, :price, :category_id)
  end
end
