module Aceroute
class Customer
  attr_accessor :locations
  attr_accessor :email
  attr_accessor :name
  attr_accessor :cid

  def initialize(name, email, location = {}, cid = nil)
    self.locations = []
    #create getters/setters for each param
    self.email = email
    self.name = name
    self.cid = cid

    if !location.empty?
      locations << Aceroute::Location.new(*location)
    end

  end



  # @return [Aceroute::Customer]
  def create!
    recs = "<data>
      <cst>
        <nm>#{self.name}</nm>
        <locnm>#{self.locations.first.description}</locnm>
        <adr>#{self.locations.first.address1}</adr>
        <adr2>#{self.locations.first.address2}</adr2>
        <cntnm>#{self.locations.first.name}</cntnm>
        <tel>#{self.locations.first.phone}</tel>
        <eml>#{self.email}</eml>
      </cst>
    </data>"

    data = Aceroute::call_api("customer.create", recs)
    location = data.locs.loc
    customer = data.cnts.cnt
    update_attrs(customer)
    self.cid = customer.cid
    locations.first.update_attrs(location)
    return self
  end





  def destroy!
    req = "<data><del><id>#{self.cid}</id></del></data>"
    ret = Aceroute::call_api("customer.delete", req)
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
