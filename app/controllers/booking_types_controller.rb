class BookingTypesController < ApplicationController
  before_action :set_booking_type, only: %i[ show edit update destroy ]

  def index
    @booking_types = current_user.booking_types
  end

  def show
  end

  def new
    @booking_type = current_user.booking_types.new
  end

  def edit
  end

  def create
    @booking_type = current_user.booking_types.new(booking_type_params)

    respond_to do |format|
      if @booking_type.save
        format.html { redirect_to root_path, notice: "Booking type was successfully created." }

      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end

  end

  def update
    respond_to do |format|
      if @booking_type.update(booking_type_params)
        format.html { redirect_to root_path, notice: "Booking type was successfully updated."}
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking_type.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: "Booking type was successfully destroyed."}
    end
  end

  private

    def set_booking_type
      @booking_type = BookingType.find(params[:id])
    end

    def booking_type_params
      params.require(:booking_type).permit(:name, :location, :description, :color, :duration, :payment_required, :price)
    end
end
