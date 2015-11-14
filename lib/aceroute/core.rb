require 'rubygems'
require 'httparty'
require 'aceroute/hashit'

module Aceroute
  include HTTParty
  debug_output $stdout
  attr_accessor :http_result

  base_uri 'http://air.aceroute.com'
  @@API_KEY = ENV['ACEROUTE_API_TOKEN']

  @@query_params = {
    token: @@API_KEY,
    updsince: '0'
  }



  def self.list_customers
    self.call_api("customer.list", nil)
  end



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
    address = data.locs.loc
    customer = data.cnts.cnt
    return customer, address
  end


  def self.delete_customer(customer_id)
    recs = "<data><del><id>#{customer_id}</id></del></data>"
    self.call_api("customer.delete", recs)
  end



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



  def self.delete_location(location_id)
    recs = "<data><del><id>#{location_id}</id></del></data>"
    types = self.call_api("customer.location.delete", recs).otype
  end


  def self.list_order_types
    self.call_api("order.type.list", nil)
  end

  def self.list_service_types
    self.call_api("product.type.list", nil)
  end


  def self.list_workers
    workers = self.call_api("worker.list", nil).res
  end

  def self.list_orders
    workers = self.call_api("order.list", nil).event
  end


  def self.create_order_old(order)
    recs = "<data><event>
      <cid>#{order[:customer][:cid]}</cid>
      <lid>#{order[:customer][:location_id]}</lid>
      <cntid>#{order[:customer][:contact_id]}</cntid>
      <rid>#{order[:worker_id]}</rid><tid>#{order[:type_id]}</tid>
      <pid>1</pid><dur>#{order[:duration]}</dur>
      <start_epoch>#{order[:start_time_epoch]}</start_epoch>
      <nm>#{order[:name]}</nm><dtl>#{order[:summary]}</dtl>
      <po>po59</po><inv>invoice 1</inv>
      <note>order notes</note><schd>1</schd>
      </event></data>"
      puts recs
      data = self.call_api("order.create", recs)
  end


  def self.create_order(order)
    #required:
    #  cid (customer id)
    #  nm ('name' descriptive field)
    #  dur (order duration in minutes, 5 min increments)
    #  sched (1 = scheduled, 0 = unscheduled)
    #  start_epoch (time in msec)

    recs = "<data>
          <event>
            <cid>#{order[:cid]}</cid>
            <nm>#{order[:nm]}</nm>
            <dur>#{order[:dur]}</dur>
            <schd>#{order[:schd]}</schd>
            <start_epoch>#{order[:start_epoch]}</start_epoch>
          </event>
        </data>"
    puts recs
    data = self.call_api("order.create", recs)
    puts data
    order = data.event
  end


  def self.delete_order(order_id)
    recs = "<data><del><id>#{order_id}</id></del></data>"
    self.call_api("order.delete", recs)
  end

  def self.call_api(method, recs)
    params = @@query_params.merge!({method: method})
    params[:recs] = recs unless recs.nil?
    options = {query: params}
    #puts "options: " + options.to_s
    http_result = self.get("/api", options).parsed_response
    puts http_result
    data = Hashit.new(http_result['data'])
  end


end