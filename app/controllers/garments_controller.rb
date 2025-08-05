class GarmentsController < ApplicationController
  before_action :set_garment, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @categories = Category.all

    if params.dig(:search, :query).present?
      query = params[:search][:query]
      @garments = Garment.where("title ILIKE ?", "%#{query}%")
    elsif params[:category].present?
      @selected_category = Category.find_by(id: params[:category])
      @garments = @selected_category.present? ? @selected_category.garments : Garment.none
    else
      @garments = Garment.all
    end
  end

  def show
  end

  def new
    @garment = Garment.new
  end

  def edit
  end

  def create
    @garment = Garment.new(garment_params)

    if @garment.save
      create_stripe_product(@garment)
      redirect_to @garment
    else
      flash.now[:alert] = "Could not create garment: #{@garment.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @garment.update(garment_params)
      redirect_to @garment
    else
      flash.now[:alert] = "Could not update garment: #{@garment.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @garment.stripe_product_id.present?
      begin
        Stripe::Product.update(@garment.stripe_product_id, { active: false })
      rescue Stripe::InvalidRequestError => e
        Rails.logger.error("Stripe error while archiving product: #{e.message}")
      end
    end

    @garment.destroy
    redirect_to garments_path
  end

  def create_stripe_product(garment)
    images = garment.cloudinary_photos.presence || []

    product_params = {
      name: garment.title,
      description: garment.description
    }
    product_params[:images] = images if images.any?

    stripe_product = Stripe::Product.create(product_params)

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
    params.require(:garment).permit(
      :title,
      :description,
      :category_id,
      :brand,
      :size,
      :price,
      :cloudinary_photos_raw
    )
  end

  def set_garment
    @garment = Garment.find(params[:id])
  end
end
