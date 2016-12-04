module Aceroute
class Order < Base
  attr_accessor :customer, :location, :start_time #in msec (not sec) since epoch
  attr_accessor :description, :duration, :scheduled, :worker, :summary, :purchase_order #any freeform text here
  attr_accessor :cid, :id





  #Creates a new Aceroute::Order object. Note this does not
  #persist the Location to Aceroute, that can be done by calling the
  #create! method on the new object.
  # @param customer [Aceroute::Customer] recipient of this Order
  # @param location [Aceroute::Location] location of this Order (delivery destination)
  # @param start_time [Integer] start time of Order, in msec since epoch (note: msec not sec)
  # @param description [String] description of Order (e.g., contents of order)
  # @param duration [Integer] duration of Order in minutes (time to service customer); used to aid in route optimization. Defaults to 10 minutes
  # @param scheduled [Boolean] whether this Order is scheduled or not; defaults to true
  # @param worker [Integer] Worker ID of aceroute worker to assign this Order to; defaults to nil (not implemented)
  # @param summary [String] Summary of order, to be displated in app. Defaults to none.
  # @param purchase_order [String] arbitrary string to indicate PO or other note, if needed
  # @return [Aceroute::Order]
  def initialize(customer, location, start_time, description = nil, duration = 10,
    scheduled = true, worker = nil, summary = nil, purchase_order = nil)
    self.customer = customer
    self.location = location
    self.start_time = start_time
    #FIXME: taking a DateTime argument is friendlier
    #self.start_time = start_time.to_i * 1000 #DateTime object
    self.description = description
    self.duration = duration
    self.scheduled = scheduled
    self.worker = worker
    self.summary = summary
    self.purchase_order = purchase_order
  end



    # Persists Aceroute::Order object to Aceroute API.
    # @return [Aceroute::Order]
    def create!
      recs = "<data>
            <event>
              <cid>#{self.customer.cid}</cid>
              <nm>#{self.description}</nm>
              <dur>#{self.duration}</dur>
              <schd>#{self.scheduled ? 1 : 0}</schd>
              <start_epoch>#{self.start_time}</start_epoch>
              <lid>#{self.location.id}</lid>
              <cntid>#{0}</cntid>
              <rid>#{self.worker}</rid>
              <dtl>#{self.summary}</dtl>
              <po>#{self.purchase_order}</po>
            </event>
          </data>"
      data = Aceroute::call_api("order.create", recs)
      order = data.event
      update_attrs(order)
      return self
    end


    # Deletes this Aceroute::Order object (self) from Aceroute
    def destroy!(id = nil)
      Order.delete(id ? id : self.id)
    end


    # Deletes Aceroute::Location of given id from Aceroute
    # @param id [Integer]
    def self.delete(id)
      req = "<data><del><id>#{id}</id></del></data>"
      ret = Aceroute::call_api("order.delete", req)
      ret.success == "true" ? true : false  #maybe raise error here instead
    end


end
end
