module Aceroute
class Location
  attr_accessor :address1
  attr_accessor :address2
  attr_accessor :description
  attr_accessor :name
  attr_accessor :phone
  attr_accessor :cid, :id


  def initialize(address1, address2, description, name, phone, cid = nil, id= nil)
    #create getters/setters for each param
    #attrs.each do |name,value|
    #  singleton_class.class_eval {attr_accessor "#{name}"}
    #   send("#{name}=", value)
    #end
    self.address1 = address1
    self.address2 = address2
    self.description = description
    self.name = name
    self.phone = phone
    self.cid = cid
    self.id = id
  end


  # @return Aceroute location object
  def create!
    recs = "<data><loc><id>0</id>
      <cid>#{self.cid}</cid>
      <nm>#{self.description}</nm>
      <adr>#{self.address1}</adr>
      <adr2>#{self.address2}</adr2>
      </loc></data>"
    data = Aceroute::call_api("customer.location.save", recs)
    loc = data.loc
    update_attrs(loc)
    return self
  end


  def destroy!
    req = "<data><del><id>#{self.id}</id></del></data>"
    ret = Aceroute::call_api("customer.location.delete", req)
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
