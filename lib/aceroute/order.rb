module Aceroute
class Order
  attr_accessor :customer, :location, :start_time #in msec since epoch
  attr_accessor :description, :duration, :scheduled, :worker, :summary, :purchase_order #any freeform text here


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
    # @return [Order] order
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



    def destroy!
      req = "<data><del><id>#{self.id}</id></del></data>"
      ret = Aceroute::call_api("order.delete", req)
      ret.success == "true" ? true : false  #maybe raise error here instead
    end


    #private
    #takes a Hashit class, extracts the instance variables, and sets them on our Customer
    def update_attrs(hashit)
      hashit.instance_variables.each do |name|
        singleton_class.class_eval {attr_accessor "#{name[1..-1]}"} #remove leading @ from varname
        send("#{name[1..-1]}=", hashit.instance_variable_get(name))
      end
    end



end
end
