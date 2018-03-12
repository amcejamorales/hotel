module Hotel

  class Guest

    attr_reader :id, :name, :phone, :credit_card_number

    def initialize(id, name, phone, credit_card_number)
      @id = id
      @name = name
      @phone = phone
      @credit_card_number = credit_card_number
    end

  end # class Guest

end # module Hotel
