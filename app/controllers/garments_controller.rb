class GarmentsController < ApplicationController

  def index
    @garment = Garment.all
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

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def garment_params
    params.require(:garment).permit(:title, :description, :brand, :category, :photo)
  end
end
