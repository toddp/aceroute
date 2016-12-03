require 'rubygems'
require 'httparty'
require 'aceroute/hashit'
require 'aceroute/customer'
require 'aceroute/location'
require 'aceroute/order'

module Aceroute
  include HTTParty
  @@DEBUG = true
  debug_output $stdout if @@DEBUG
  attr_accessor :http_result


  base_uri 'http://air.aceroute.com'
  @@API_KEY = ENV['ACEROUTE_API_TOKEN']


  @@query_params = {
    token: @@API_KEY,
    updsince: '0'
  }


  # List all customers
  # @return [Hash] list of customer objects
  def self.list_customers
    customers = []
    res = self.call_api("customer.list", nil)
    binding.pry
    res.cnts.cnt.each do |r|
      c = Aceroute::Customer.new(name: r['nm'], email: r['eml'],
        cid: r['cid'])
      customers << c
      #find corresponding addresses for this customer
      locations = res.locs.loc.find_all{|l| l["cid"] == c.cid }
      locations.each do |a|
        binding.pry
        c.locations << Aceroute::Location.new(address1: a['adr'], address2: a['adr2'],
          phone: a['tel'], description: a['nm'])
      end
    end
    customers
  end


  # Create a new customer
  # @param customer [Hash]
  #   * :name (String) the name of customer
  #   * :email (String) the email for this customer
  #   * :address [Hash]
  #     * :description (String) the description of this address, eg 'home'
  #     * :address1 (String) line 1 of the address, eg '123 Fake Street'
  #     * :address2 (String) line 2 of the address, eg 'New York, NY 12345'
  #     * :name (String) address name
  #     * :phone (String) address phone number
  # @return [Hash] customer and address
  def self.create_customer(customer)
    recs = "<data>
      <cst>
        <nm>#{customer[:name]}</nm>
        <locnm>#{customer[:address][:description]}</locnm>
        <adr>#{customer[:address][:address1]}</adr>
        <adr2>#{customer[:address][:address2]}</adr2>
        <cntnm>#{customer[:address][:name]}</cntnm>
        <tel>#{customer[:address][:phone]}</tel>
        <eml>#{customer[:email]}</eml>
      </cst>
    </data>"

    data = self.call_api("customer.create", recs)
    location = data.locs.loc
    customer = data.cnts.cnt
    return customer, location
  end


  # Delete a customer
  # @param customer_id [Integer] id of Aceroute Customer object
  # @return success or failure hash
  def self.delete_customer(customer_id)
    recs = "<data><del><id>#{customer_id}</id></del></data>"
    self.call_api("customer.delete", recs)
  end


  # Create a new location
  # @param location [Hash]
  #   * :id (Integer)
  #   * :description (String) the description of this address, eg 'home'
  #   * :address1 (String) line 1 of the address, eg '123 Fake Street'
  #   * :address2 (String) line 2 of the address, eg 'New York, NY 12345'
  #   * :customer
  #     * :cid (Integer) cid from Aceroute Customer object
  # @return Aceroute location object
  def self.create_location(location)
    recs = "<data><loc><id>#{location[:id]}</id>
      <cid>#{location[:customer][:cid]}</cid>
      <nm>#{location[:description]}</nm>
      <adr>#{location[:address1]}</adr>
      <adr2>#{location[:address2]}</adr2>
      </loc></data>"
    data = self.call_api("customer.location.save", recs)
    loc = data.loc
  end


  # Delete a location
  # @param location_id (Integer) id from Aceroute Location object
  # @return nil
  def self.delete_location(location_id)
    recs = "<data><del><id>#{location_id}</id></del></data>"
    types = self.call_api("customer.location.delete", recs).otype
  end

  # List order types
  # @return list of available order types for this account
  def self.list_order_types
    self.call_api("order.type.list", nil)
  end

  # List service types
  # @return list of available service types for this account
  def self.list_service_types
    self.call_api("product.type.list", nil)
  end


  # List all workers
  # @return list of available workers for this account
  def self.list_workers
    workers = self.call_api("worker.list", nil).res
  end

  # List all orders
  # @return list of all orders in this account
  def self.list_orders
    workers = self.call_api("order.list", nil).event
  end




  # Create new order
  # @param order [Hash]
  #   * :cid (Integer) Aceroute customer id
  #   * :nm (String) 'name', descriptive field for this order
  #   * :dir (Integer) 'duration', in 5 minute increments
  #   * :sched (Integer) 1 = scheduled, 0 = unscheduled
  #   * :start_epoch (Integer) time in msec since epoch
  #   * :lid (Integer) optional -- customer location id
  #   * :cntid (Integer) optional -- customer contact id
  #   * :rid (Integer) optional -- worker id, to assign this order to a specific worker
  #   * :dtl (String) optional -- order summary
  #   * po (String) optional -- 'purchase order', descriptive field for use as desired
  # @return Aceroute Order object
  def self.create_order(order)
    recs = "<data>
          <event>
            <cid>#{order[:cid]}</cid>
            <nm>#{order[:nm]}</nm>
            <dur>#{order[:dur]}</dur>
            <schd>#{order[:schd]}</schd>
            <start_epoch>#{order[:start_epoch]}</start_epoch>
            <lid>#{order[:lid]}</lid>
            <cntid>#{order[:cntid]}</cntid>
            <rid>#{order[:rid]}</rid>
            <dtl>#{order[:dtl]}</dtl>
            <po>#{order[:po]}</po>
          </event>
        </data>"
    puts recs if @@DEBUG
    data = self.call_api("order.create", recs)
    puts data if @@DEBUG
    order = data.event
  end

  # Delete an order
  def self.delete_order(order_id)
    recs = "<data><del><id>#{order_id}</id></del></data>"
    self.call_api("order.delete", recs)
  end

private
  def self.call_api(method, recs)
    params = @@query_params.merge!({method: method})
    params[:recs] = recs unless recs.nil?
    options = {query: params}
    #puts "options: " + options.to_s
    http_result = self.get("/api", options).parsed_response
    puts http_result if @@DEBUG
    data = Hashit.new(http_result['data'])
  end

end
