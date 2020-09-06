class Start
  def initialize(client)
    @client = client
  end

  def options
    while true
      puts '*** Please select from the following options ***'
      puts '1 - Make payment'
      puts '2 - Cancel previous payment'
      puts '3 - Query a card'
      puts '4 - Exit'

      selected_option = gets.chomp
      print `clear`

      case selected_option
      when '1'
        puts 'Please enter transaction amount of less than AUD100'
        amount = gets.chomp.to_f

        puts 'This is processing... One moment please.'
        @client.payment_request({ price: amount })
      when '2'
        puts 'This is processing... One moment please.'
        @client.abort_request
      when '3'
        puts 'Please enter transaction amount of less than AUD100'
        amount = gets.chomp.to_f

        puts 'This is processing... One moment please.'
        @client.card_acquisition({ price: amount })
      when '4'
        break
      end
    end
  end
end
