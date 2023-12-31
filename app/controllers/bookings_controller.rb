class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  def show
  end

  def new
    @booking = Booking.new
    @booking_type = BookingType.find_by(name: params[:booking_type])
  end

  def edit
  end

  def create
    @booking = Booking.new(booking_params)
    @booking_type = BookingType.find(params[:booking][:booking_type_id])

    respond_to do |format|
      if @booking.save

        unless @booking_type.payment_required?
          @booking.approved!
        end

        format.html { redirect_to root_url, notice: "Booking was successfully created."}
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to root_url, notice: "Booking was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully destroyed."}
      format.json { head :no_content }
    end
  end

  def intent
    @booking_type = BookingType.find(params[:_json])
    amount = @booking_type.price * 100
    
    payment_intent = Stripe::PaymentIntent.create(
      amount: amount,
      currency: 'eur',
      automatic_payment_methods: {
        enabled: true
      },
      metadata: {
        user_id: @booking_type.user.id,
        booking_type_id: @booking_type.id
      }
    )

    respond_to do |format|
      format.json { render json: { clientSecret: payment_intent['client_secret'] } }
    end
  end

  private

    def set_booking
      @booking = Booking.find(params[:id])
    end

    def booking_params
      params.require(:booking).permit(:booking_type_id, :status, :name, :email, :start_at, :end_at, :notes)
    end
end
