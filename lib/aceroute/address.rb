class Address


  def initialize(attrs)
    #create getters/setters for each param
    attrs.each do |name,value|
      singleton_class.class_eval {attr_accessor "#{name}"}
      send("#{name}=", value)
    end
  end


  # @return Aceroute location object
  def create!
    recs = "<data><loc><id>0</id>
      <cid>#{self.cid}</cid>
      <nm>#{self.description || self.nm}</nm>
      <adr>#{self.address1 || self.adr}</adr>
      <adr2>#{self.address2 || self.adr2}</adr2>
      </loc></data>"
    data = Aceroute::call_api("customer.location.save", recs)
    loc = data.loc
    update_attrs(loc)
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
