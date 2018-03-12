require_relative "lib/reservation_manager"
require_relative "lib/hotel"
require_relative "lib/reservation"
require_relative "lib/block"

module Hotel

  class Session
    def initialize(reservation_manager)
      @reservation_manager = reservation_manager
    end

    def go
      puts "\n=========================="
      puts "\nWelcome to the reservation management system.\n\n"
      start

      while continue?
        start
      end

      conclude
    end # go

    def start
      puts "What would you like to do?"
      puts "\n=========================="
      puts "[1] Reserve a room"
      puts "[2] Create a block"
      puts "[3] Reserve from a block"
      puts "[4] Add a new guest"
      puts "==========================\n\n"
      selection = gets.chomp.to_i

      until (1..4).include?(selection)
        puts "Please enter a number from 1 to 4."
        selection = gets.chomp.to_i
      end

      case selection
      when 1
        reserve_a_room
      when 2
        create_a_block
      when 3
        reserve_from_block
      when 4
        add_new_guest
      end

    end # start

    def continue?
      puts "Would you like to do something else? (Y/N)"
      continue = gets.chomp.upcase

      until ["Y", "N"].include?(continue)
        puts "Please enter Y or N. Would you like to continue? (Y/N)"
        continue = gets.chomp.upcase
      end

      (continue == "Y") ? true : false
    end # continue?

    def conclude
      puts "\nSession complete.\n"
      puts "\n=========================="
    end # conclude

    def guest_status_and_info
      puts "Has the guest stayed with us before? (Y/N)"

      response = gets.chomp
      until ["Y", "N"].include?(response)
        puts "Please enter Y or N. Has this guest stayed with us before?"
        response = gets.chomp
      end

      existing_guest = false
      if response == "Y"
        existing_guest = true
      end

      if existing_guest
        puts "What's the guest's ID number?"
        guest_id = gets.chomp.to_i
        puts "What's the guest's full name?"
        guest_name = gets.chomp
        guest = @reservation_manager.find_guest(guest_id, guest_name)
      else
        guest = add_new_guest
      end
      guest
    end #guest_status_and_info

    def reserve_a_room
      puts "What's the start date? Please enter in this format: YYYY-MM-DD."
      start_date = gets.chomp
      puts "What's the end date? Please enter in this format: YYYY-MM-DD."
      end_date = gets.chomp

      guest = guest_status_and_info

      puts "Here are the available rooms."
      available_rooms = @reservation_manager.view_available(start_date, end_date)
      puts "#{available_rooms}"
      puts "Please choose one of the above."
      room_number = gets.chomp.to_i

      reservation = @reservation_manager.reserve_available(room_number, start_date, end_date, guest)
      puts "\n
      Reservation for room #{reservation.room_number} from #{reservation.start_date} to #{reservation.end_date} has been booked successfully for #{guest.name} at $#{reservation.rate} per night.
      \n"
    end # reserve_a_room

    def create_a_block
      puts "How many rooms do you want to put in a block?"
      num_rooms = gets.chomp.to_i
      puts "What's the start date? Please enter in this format: YYYY-MM-DD."
      start_date = gets.chomp
      puts "What's the end date? Please enter in this format: YYYY-MM-DD."
      end_date = gets.chomp
      puts "What's the rate for this block?"
      discount_rate = gets.chomp.to_f

      block = @reservation_manager.generate_block(num_rooms, start_date, end_date, discount_rate)

      puts "Block number #{block.id} for #{block.start_date} to #{block.end_date} with a rate of $" '%.2f' % "#{discount_rate}" + " has successfully been created."
    end # create_a_block

    def reserve_from_block
      puts "What's the block ID?"
      block_id = gets.chomp.to_i
      block = @reservation_manager.find_block(block_id)

      puts "The following rooms are available in block #{block.id}: "
      available_rooms = @reservation_manager.available_in_block(block.id)
      puts "#{available_rooms}"
      puts "Please choose one of the above."
      room_number = gets.chomp.to_i

      guest = guest_status_and_info

      reservation = @reservation_manager.reserve_in_block(block_id, room_number, guest)

      puts "Room number #{reservation.room_number} has been booked from #{reservation.start_date} to #{reservation.end_date} for #{guest.name} in block #{block_id} at $" '%.2f' % "#{reservation.rate}" + " per night."
    end # reserve_from_block

    def add_new_guest
      puts "What's the guest's full name?"
      guest_name = gets.chomp
      puts "What's the guest's phone number? Please enter in this format: (XXX) XXX-XXXX."
      guest_phone = gets.chomp
      puts "What's the guest's credit card number? Please enter in this format: XXXX-XXXX-XXXX-XXXX."
      guest_credit_card_number = gets.chomp
      guest = @reservation_manager.create_new_guest(guest_name, guest_phone, guest_credit_card_number)

      puts "A new account has been made for #{guest.name}."
      guest
    end # add_new_guest

  end # class Session

end # module Hotel

reservation_manager = Hotel::ReservationManager.new
reservation_manager.generate_block(5, "2018-04-10", "2018-04-15", 150.00)
reservation_manager.create_new_guest("Diana Prince", "(210) 555-5555", "1111-2222-3333-4444")

session = Hotel::Session.new(reservation_manager)

session.go
