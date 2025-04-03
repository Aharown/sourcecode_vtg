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

    if params[:garment][:photos].present?
      params[:garment][:photos].each do |photo|
        @garment.photos.attach(photo)
      end
    end

    if params[:remove_photos].present?
      params[:remove_photos].each do |photo_id|
        @garment.photos.find(photo_id).purge
      end
    end

    if @garment.update(garment_params.except(:photos))
      redirect_to @garment, notice: 'Garment was successfully updated.'
    else
      render :edit
    end
  end

  def purchase
    @garment = Garment.find(params[:id])

    if @garment.stock_quantity.positive?
      create_stripe_session(@garment)
    end
  end

  def create_stripe_session(garment)
    session = Stripe::Checkout::Session.create({
      payment_method_types: ['card'],
      line_items: [{
        name: garment.name,
        amount: garment.price_pence,  # assuming the price is in cents
        currency: 'gbp',
        quantity: 1,
      }],
      success_url: garments_url,   # URL to redirect to after successful payment
      cancel_url: garments_url,    # URL to redirect to if the payment is canceled
    })

    redirect_to session.url, allow_other_host: true
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
    params.require(:garment).permit(:title, :description, :category_id, :brand, :size, :price, photos: [])
  end

  def set_garment
    @garment = Garment.find(params[:id])
  end

end
