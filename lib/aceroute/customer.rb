module Aceroute
class Customer < Base
  attr_accessor :locations
  attr_accessor :email
  attr_accessor :name
  attr_accessor :cid, :id

  #Creates a new Aceroute::Customer object. Note this does not
  #persist the Customer to Aceroute, that can be done by calling the
  #create! method on the new object.
  # @param name [String] customer name
  # @param email [String] customer email
  # @param location [Hash] customer Location, optional
  # @param cid [Integer] Aceroute customer id, optional; useful for instantiating Customer objects from Aceroute API response
  # @return [Aceroute::Customer]
  def initialize(name, email, location = {}, cid = nil)
    self.locations = []
    #create getters/setters for each param
    self.email = email
    self.name = name
    self.cid = cid

    if !location.empty?
      locations << Aceroute::Location.new(location[:address1], location[:address2], location[:description],
      location[:name], location[:phone])
    end
  end


  # Persists Customer object to Aceroute API.
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

    #puts recs
    data = Aceroute::call_api("customer.create", recs)
    location = data.locs.loc
    customer = data.cnts.cnt
    update_attrs(customer)
    self.cid = customer.cid
    locations.first.update_attrs(location)
    return self
  end

  # Deletes this Aceroute::Customer object (self) from Aceroute;
  def destroy!(id = nil)
    Customer.delete(id ? id : self.cid)
  end

  # Deletes Aceroute::Customer of given id from Aceroute
  # @param id [Integer]
  def self.delete(id)
    recs = "<data><del><id>#{id}</id></del></data>"
    ret = Aceroute::call_api("customer.delete", recs)
    ret.success == "true" ? true : false
  end

end
end
