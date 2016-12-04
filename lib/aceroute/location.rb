module Aceroute
class Location < Base
  attr_accessor :address1
  attr_accessor :address2
  attr_accessor :description
  attr_accessor :name
  attr_accessor :phone
  attr_accessor :cid, :id


  #Creates a new Aceroute::Location object. Note this does not
  #persist the Location to Aceroute, that can be done by calling the
  #create! method on the new object.
  # @param address1 [String] customer address line 1 (street)
  # @param address2 [String] customer address line 2 (eg apartment number)
  # @param description [String] description of address (eg 'Home')
  # @param name [String] name of address (eg 'Home')
  # @param phone [String] phone number associated with this address
  # @param cid [Integer] Aceroute customer id, optional; associates this Location with that Customer
  # @param id [Integer] Aceroute location id, optional; useful for instantiating Location objects from Aceroute API response
  # @return [Aceroute::Location]
  def initialize(address1, address2, description, name, phone, cid = nil, id= nil)
    self.address1 = address1
    self.address2 = address2
    self.description = description
    self.name = name
    self.phone = phone
    self.cid = cid
    self.id = id
  end


  # Persists Aceroute::Location object to Aceroute API.
  # @return [Aceroute::Location]
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

  # Deletes this Aceroute::Location object (self) from Aceroute
  def destroy!(id = nil)
    Location.delete(id ? id : self.id)
  end

  # Deletes Aceroute::Location of given id from Aceroute
  # @param id [Integer]
  def self.delete(id)
    req = "<data><del><id>#{id}</id></del></data>"
    ret = Aceroute::call_api("customer.location.delete", req)
    ret.success == "true" ? true : false  #maybe raise error here instead
  end

end
end
