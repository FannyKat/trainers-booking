class HomeController < ApplicationController
  def index
    @users = User.all
    @booking_types = BookingType.all
  end

  def dashboard
    @booking_types = current_user.booking_types
    @bookings = Booking.where(booking_type_id: current_user.booking_type_ids)
  end
end
