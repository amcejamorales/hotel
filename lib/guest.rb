module Hotel

  class Guest

    attr_reader :id, :name, :phone, :credit_card_number

    def initialize(id, name, phone, credit_card_number)
      @id = id
      @name = name
      @phone = phone
      @credit_card_number = credit_card_number
    end

    def find_guest(guest_id, guest_name)
      if @id == guest_id && @name == guest_name
        return true
      end
    end # find_guest

  end # class Guest

end # module Hotel
