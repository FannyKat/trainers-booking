module BookingTypesHelper
  def duration(type)
      if type.duration == 60
        "1 hr"
      else
        type.duration.to_formatted_s + " mins"
      end
    end

  def price(type)
    if type.price.nil?
      "Gratuit"
    else
      type.price.to_formatted_s + " €"
    end
  end

  def find_username(user_id)
    User.find_by(id: user_id).name
  end
end
