class GarmentsController < ApplicationController
  before_action :set_garment, only: [:show, :edit, :update, :destroy]

  def index
    @garments = Garment.all
  end

  def show
  end

  def new
    @garment = Garment.new
  end

  def create
    @garment = current_user.garments.build(garment_params)
    if @garment.save
      redirect_to user_path(current_user), notice: 'Listing is live 🔥'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @garment = Garment.find(params[:id])
    existing_photos = @garment.photos

    if @garment.update(garment_params)
      # Check if photos should be removed
      if params[:remove_photos]
        params[:remove_photos].each do |photo_id|
          @garment.photos.find(photo_id).purge # This will remove the selected photos
        end
      end
      redirect_to @garment, notice: 'Garment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @garment = Garment.find(params[:id])
    if @garment.destroy
      redirect_to user_path(current_user), notice: "Listing has been deleted 🗑️."
    else
      redirect_to garments_path, alert: "Failed to delete the listing 🛑."
    end
  end

  private

  def garment_params
    params.require(:garment).permit(:title, :description, :category_id, :brand, :size, :rental_price, photos: [])
  end

  def set_garment
    @garment = Garment.find(params[:id])
  end
end
