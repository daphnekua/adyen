# Adyen POS Integration for Ruby 

This integration lets you connect with Adyen's POS via API.

## Integration

The integration supports the following: 
	• The ability to process a payment: payment_request
	• The ability to cancel a payment: abort_request
 	• The ability to query a cards details: card_acquisiton

## Requirements

Built with Ruby >= 2.6.6

## Usage 

- Create a 'auth.rb' file and add the following: 
    API_KEY = [to be obtained from Adyen]
    TERMINAL = [to be obtained from Adyen]
- Run the 'adyen_gateway.rb' file on your system's Terminal 
- Run through the list of options presented 
- Exit the program 
- Set a new @service_id number found in 'adyen_gateway.rb' file each time you run the program as the API requires unique service_id number

## List of supported methods  

**payment_request**
- This would send a payment request to the POS, where the POS would prompt user for their card. 
- The program would prompt you to enter a transaction amount (limited to AUD).
- Upon hitting 'enter', the program would call Adyen's Terminal API to send this payment request to the POS. 
    
**abort_request**
- Upon selecting this option, the program would cancel the previous payment request that has been made.

**card_acquisition**
- This would send a request to the POS to prompt user for their card to retrieve card and shopper details. 
- The program would prompt you to enter a transaction amount (limited to AUD).
- Upon hitting 'enter', the program would call Adyen's Terminal API to send this request to the POS to check on the user's card. 
- Note: This request takes slightly longer to be processed (~1.5 min). 
