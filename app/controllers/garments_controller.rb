class GarmentsController < ApplicationController
  before_action :set_garment, only: [:show, :edit, :update, :destroy]

  def index
    @garments = Garment.all
  end

  def show
    @garment = Garment.find(params[:id])
  end

  def new
    @garment = Garment.new
  end

  def create
    @garment = Garment.new(garment_params)
    if @garment.save
      redirect_to @garment
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @garment.update(garment_params)
      redirect_to @garment, notice: "Listing has been updated ✅."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @garment.destroy
      redirect_to garments_path, notice: "Listing has been deleted 🗑️."
    else
      redirect_to garments_path, alert: "Failed to delete the listing 🛑."
    end
  end

  private

  def garment_params
    params.require(:garment).permit(:title, :description, :brand, :category, :photo)
  end

  def set_garment
    @garment = Garment.find(params[:id])
  end
end
