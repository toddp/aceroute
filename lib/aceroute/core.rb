require 'rubygems'
require 'httparty'
require 'aceroute/hashit'

module Aceroute
  include HTTParty
  debug_output $stdout
  attr_accessor :http_result

  base_uri http://air.aceroute.com
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
    self.call_api("customer.delete")
  end



  def self.create_location(location)
    recs = "<data>
          <loc>
            <id>#{location[:id]}</id>
            <cid>#{location[:customer][:cid]}</cid>
            <nm>#{location[:description]}</nm>
            <adr>#{location[:address1]}</adr>
            <adr2>#{location[:address2]}</adr2>
          </loc>
        </data>"
    self.call_api("customer.location.save", recs)
  end



  def self.delete_location(location_id)
    recs = "<data><del><id>#{location_id}</id></del></data>"
    self.call_api("customer.location.delete", recs)
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
            <nm>#{order[:description]}</nm>
            <dur>#{order[:dur]}</dur>
            <sched>#{order[:sched]}</sched>
            <start_epoch>#{order[:start_epoch]}</start_epoch>
            <lid>#{order[:lid]}</lid>
            <cntid>#{order[:cntid]}</cntid>
            <rid>#{order[:rid]}</rid>
            <tid>#{order[:tid]}</tid>
            <pid>#{order[:pid]}</pid>
            <dtl>#{order[:dtl]}</dtl>
            <po>#{order[:po]}</po>
            <inv>#{order[:inv]}</inv>
            <note>#{order[:note]}</note>
          </event>
        </data>"
    self.call_api("order.save", recs)
  end
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