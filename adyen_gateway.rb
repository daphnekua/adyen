require_relative 'auth'
require_relative 'start'
require 'uri'
require 'net/http'
require 'json'
require 'date'

class AdyenGateway
  def initialize
    @api_key = API_KEY
    @terminal = TERMINAL
    @endpoint = URI('https://terminal-api-test.adyen.com/sync')
    @service_id = 1000000237
    @https = Net::HTTP.new(@endpoint.host, @endpoint.port)
    @https.use_ssl = true
  end

  def payment_request(params)
    request = Net::HTTP::Post.new(@endpoint)
    request['x-API-key'] = @api_key
    request['Content-Type'] = 'application/json'
    request.body = build_request(params)
    response = @https.request(request)
    puts JSON.pretty_generate(JSON.parse(response.read_body))
    @service_id += 1

    puts '*** There is an error, kindly initialize with a new service_id ***' if JSON.parse(response.body)['SaleToPOIResponse']['PaymentResponse']['Response']['Result'] != 'Success'
  end

  def abort_request
    request = Net::HTTP::Post.new(@endpoint)
    request['x-API-key'] = @api_key
    request['Content-Type'] = 'application/json'
    request.body = build_cancel
    response = @https.request(request)
    @service_id += 1

    puts '> Transaction has been cancelled' if response.read_body == 'ok'
  end

  def card_acquisition(params)
    request = Net::HTTP::Post.new(@endpoint)
    @https.read_timeout = 150000
    request['x-API-key'] = @api_key
    request['Content-Type'] = 'application/json'
    request.body = query_card(params)
    response = @https.request(request)
    puts JSON.pretty_generate(JSON.parse(response.read_body))
    @service_id += 1

    puts '> There is an error, kindly initialize with a new service_id ***' if JSON.parse(response.body)['SaleToPOIResponse']['CardAcquisitionResponse']['Response']['Result'] == 'Failure'
  end

  private

  def build_request(params = {})
    {
      SaleToPOIRequest: {
        MessageHeader: {
          ProtocolVersion: '3.0',
          MessageClass: 'Service',
          MessageCategory: 'Payment',
          MessageType: 'Request',
          SaleID: 'POSSystemID38748',
          ServiceID: @service_id.to_s,
          POIID: @terminal
        },
        PaymentRequest: {
          SaleData: {
            SaleTransactionID: {
              TransactionID: '00037',
              TimeStamp: Time.new.strftime('%Y-%m-%dT%H:%M:%S+00:00')
            }
          },
          PaymentTransaction: {
            AmountsReq: {
              Currency: 'AUD',
              RequestedAmount: params[:price]
            }
          }
        }
      }
    }.to_json
  end

  def build_cancel
    {
      SaleToPOIRequest: {
        MessageHeader: {
          ProtocolVersion: '3.0',
          MessageClass: 'Service',
          MessageCategory: 'Abort',
          MessageType: 'Request',
          SaleID: 'POSSystemID38746',
          ServiceID: (@service_id - 1).to_s,
          POIID: @terminal
        },
        AbortRequest: {
          AbortReason: 'MerchantAbort',
          MessageReference: {
            MessageCategory: 'Payment',
            SaleID: 'POSSystemID38748',
            ServiceID: @service_id.to_s
          }
        }
      }
    }.to_json
  end

  def query_card(params = {})
    {
      SaleToPOIRequest: {
        MessageHeader: {
          ProtocolVersion: '3.0',
          MessageClass: 'Service',
          MessageCategory: 'CardAcquisition',
          MessageType: 'Request',
          SaleID: 'POSSystemID38748',
          ServiceID: @service_id.to_s,
          POIID: @terminal
        },
        CardAcquisitionRequest: {
          SaleData: {
            SaleTransactionID: {
              TransactionID: '00067',
              TimeStamp: Time.new.strftime('%Y-%m-%dT%H:%M:%S+00:00')
            },
            TokenRequestedType: 'Customer'
          },
          CardAcquisitionTransaction: {
            TotalAmount: params[:price]
          }
        }
      }
    }.to_json
  end
end

client = AdyenGateway.new
start = Start.new(client)
start.options
