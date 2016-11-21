class Customer
  attr_accessor :addresses

  def initialize(attrs)
    self.addresses = []
    #create getters/setters for each param

    attrs.each do |name,value|
      singleton_class.class_eval {attr_accessor "#{name}"}
      send("#{name}=", value)
    end
  end



  # @return [Hash] customer and address
  def create!
    recs = "<data>
      <cst>
        <nm>#{self.name}</nm>
        <locnm>#{self.addresses.first.description}</locnm>
        <adr>#{self.addresses.first.address1}</adr>
        <adr2>#{self.addresses.first.address2}</adr2>
        <cntnm>#{self.addresses.first.name}</cntnm>
        <tel>#{self.addresses.first.phone}</tel>
        <eml>#{self.email}</eml>
      </cst>
    </data>"

    data = Aceroute::call_api("customer.create", recs)
    address = data.locs.loc
    customer = data.cnts.cnt
    update_attrs(customer)
    addresses.first.update_attrs(address)
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
