class GarmentsController < ApplicationController
  before_action :set_garment, only: [:show]
  before_action :require_admin, only: [:new, :edit]

  def index
    @garments = Garment.all
  end

  def show
  end

  def new
    @garment = Garment.new
  end

  def edit
    @garment = Garment.find(params[:id])
  end

  def create
    @garment = Garment.new(garment_params)

    if params[:garment][:photos].present?
      params[:garment][:photos].each do |photo|
        @garment.photos.attach(photo)
      end
    end

    if @garment.save
      create_stripe_product(@garment)

      redirect_to @garment
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @garment = Garment.find(params[:id])
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

  def destroy
    @garment = Garment.find(params[:id])

    if @garment.stripe_product_id.present?
      begin
        Stripe::Product.update(@garment.stripe_product_id, { active: false })
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error("Stripe error while archiving product: #{e.message}")
      end
    end

    @garment.destroy
    redirect_to garments_path, notice: 'Garment deleted successfully.'
  end

  def create_stripe_product(garment)
    images = garment.photos.map { |photo| url_for(photo) }

    stripe_product = Stripe::Product.create({
      name: garment.title,
      description: garment.description,
      images: images
    })

    stripe_price = Stripe::Price.create({
      product: stripe_product.id,
      unit_amount: (garment.price * 100).to_i,
      currency: 'gbp',
    })

    garment.update(
      stripe_product_id: stripe_product.id,
      stripe_price_id: stripe_price.id
    )
  end

  private

  def garment_params
    params.require(:garment).permit(:title, :description, :category_id, :brand, :size, :price, photos: [])
  end

  def set_garment
    @garment = Garment.find(params[:id])
  end

end
